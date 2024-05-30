//
//  ApiRequest.swift
//
//
//  Created by Daniel Crespo Duarte on 3/05/24.
//

import Foundation

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

public enum StatusCodes: Int {
    case successStatusCode = 200
    case noContent = 204
    case redirectionStatusCode = 300
    case badRequestStatusCode = 400
    case notAuthenticatedStatusCode = 401
    case unauthorizedStatusCode = 403
    case pageNotFound = 404
    case internalServerErrorStatusCode = 500
    case fraudTXN = 451
    case systemOutageCodes
    
    public init(from rawValue: Int) {
        guard !(501...599 ~= rawValue) else {
            self = .systemOutageCodes
            return
        }
        self = StatusCodes(rawValue: rawValue) ?? .internalServerErrorStatusCode
    }
}

public enum ApiNetworkError: Error, Equatable {
    case serviceError(description: String)
    case unauthorized
    case parseIssue
    case serverUnresponsive
    case emptyJson
    case noContent
    case malformedURL
    case missingToken
    case missingTruevaultDocumentIdOrProviderId
    case missingAuthorizationType
    case authorizationTypeNotSupportedByClient(description: String)
    case missingField
    case badUrlFormat
    case fraud
    case pageNotFound
    case serverError
    case unexpectedEmptyRegex
    case systemOutage
    case defaultError
    case badRequest(
        description: String?,
        title: String?,
        data: Data?
    )
    
    init?(statusCode: StatusCodes, description: String? = nil, data: Data? = nil) {
        switch statusCode {
        case .badRequestStatusCode:
            self = .badRequest(description: description, title: nil, data: data)
        case .pageNotFound:
            self = .pageNotFound
        case .notAuthenticatedStatusCode:
            self = .missingToken
        case .unauthorizedStatusCode:
            self = .unauthorized
        case .internalServerErrorStatusCode:
            self = .serverError
        case .systemOutageCodes:
            self = .systemOutage
        case .noContent:
            self = .noContent
        case .fraudTXN:
            self = .fraud
        default:
            self = .defaultError
        }
    }
}

public class ApiNetworkRequest<Response> {
    let method: HTTPMethod
    let relativePath: String
    let headers: [String: String]?
    let parameters: [String: Any]?
    let authorizationToken: String?
    let apiKey: String?
    
    public init(method: HTTPMethod = .GET,
         relativePath: String,
         headers: [String: String]? = nil,
         parameters: [String: Any]?,
         authorizationToken: String? = nil,
         apiKey: String? = nil) {
        self.method = method
        self.relativePath = relativePath
        self.headers = headers
        self.parameters = parameters
        self.authorizationToken = authorizationToken
        self.apiKey = apiKey
    }
}
