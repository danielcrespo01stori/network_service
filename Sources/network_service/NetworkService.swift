//
//  NetworkService.swift
//
//
//  Created by Daniel Crespo Duarte on 3/05/24.
//

import Foundation

public class NetworkService {
    var baseURL: URL?
    var urlSession: URLSession
    
    
    public init(url: String,
         urlSession: URLSession) {
        self.baseURL = URL(string: url)
        self.urlSession = urlSession
    }
    
    private func getRequestHeaders<Response>(_ request: ApiNetworkRequest<Response>) -> [String: String] {
        var headers: [String: String] = [:]
        headers = [
            NetworkConstants.APIClient.accept : NetworkConstants.InnerConstants.accept,
            NetworkConstants.APIClient.connection : NetworkConstants.InnerConstants.keepAlive,
        ]
        
        if let apiKey = request.apiKey {
            headers[NetworkConstants.APIClient.xApiKey] = apiKey
        }
        
        if let token = request.authorizationToken {
            headers[NetworkConstants.APIClient.authorization] = NetworkConstants.InnerConstants.bearer.replacingOccurrences(of: "%@", with: token)
        }
        
        if let customHeaders = request.headers {
            for (key, value) in customHeaders {
                headers[key] = value
            }
        }
        return headers
    }
    
    private func getBaseUrl(path: String, parameters: [String: Any] = [:]) -> URL? {
        guard let baseUrl = baseURL?.appendingPathComponent(path) else { return nil }
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)!
        
        if !parameters.isEmpty {
            urlComponents.queryItems = parameters.map {
                URLQueryItem(name: $0, value: String(describing: $1))
            }
        }
        return urlComponents.url
    }
    
    private func getUrl<Response>(_ endPoint: ApiNetworkRequest<Response>) -> URL? {
        var url: URL?
        if let parameters =  endPoint.parameters {
            if endPoint.method != .GET {
                url = getBaseUrl(path: endPoint.relativePath)
            } else {
                url = getBaseUrl(path: endPoint.relativePath, parameters: parameters)
            }
        } else {
            url = getBaseUrl(path: endPoint.relativePath)
        }
        return url
    }
    
    private func getHttpBody<Response>(_ endPoint: ApiNetworkRequest<Response>) -> Data? {
        var httpBody: Data?
        if let parameters = endPoint.parameters {
            if endPoint.method != .GET {
                let body = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                httpBody = body
            }
        }
        return httpBody
    }
    
    private func getUrlRequest<Response>(_ endPoint: ApiNetworkRequest<Response>) -> URLRequest? {
        guard let requestUrl: URL = getUrl(endPoint) else { return nil }
        let headers = getRequestHeaders(endPoint)
        var request = URLRequest(url: requestUrl)
        request.httpBody = getHttpBody(endPoint)
        request.allHTTPHeaderFields = headers
        request.httpMethod = endPoint.method.rawValue
        return request
    }
    
}

extension NetworkService: NetworkServiceType {
    public func setBaseUrl(_ baseUrl: String) {
        baseURL = URL(string: baseUrl)
    }
    
    public func request<Response>(_ endpoint: ApiNetworkRequest<Response>, completionHandler: @escaping (Result<Response, any Error>) -> Void) where Response : Decodable {
        guard let request = getUrlRequest(endpoint) else {
            completionHandler(.failure(ApiNetworkError.malformedURL))
            return
        }
        
        let task = urlSession.dataTask(with: request) { data, response, error  in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(ApiNetworkError.serverError))
                return
            }
            if !(200 ..< 203 ~= httpResponse.statusCode) {
                let statusCode = StatusCodes(from: httpResponse.statusCode)
                let error = ApiNetworkError(statusCode: statusCode) ?? .serverError
                completionHandler(.failure(error))
                return
            }
            guard let data = data else {
                completionHandler(.failure(ApiNetworkError.emptyJson))
                return
            }
            do {
                if let validateResponse = try self.decoderResponse(endpoint, data: data) {
                    completionHandler(.success(validateResponse))
                } else {
                    completionHandler(.failure(ApiNetworkError.emptyJson))
                }
            } catch (let decodingError) {
                completionHandler(.failure(decodingError))
            }
        }
        task.resume()
    }
    
    private func decoderResponse<Response: Decodable>(_ endpoint: ApiNetworkRequest<Response>, data: Data) throws -> Response? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(Response.self, from: data)
        } catch (let decodingError) {
           throw decodingError
        }
    }
}
