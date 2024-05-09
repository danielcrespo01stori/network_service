//
//  NetworkServiceType.swift
//
//
//  Created by Daniel Crespo Duarte on 3/05/24.
//

import Foundation

public protocol NetworkServiceType {
    func setBaseUrl(_ baseUrl: String)
        
    func request<Response>(
        _ endpoint: ApiNetworkRequest<Response>,
        completionHandler: @escaping (Result<Response, Error>) -> Void) where Response: Decodable
}
