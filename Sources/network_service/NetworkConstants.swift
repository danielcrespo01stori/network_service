//
//  NetworkConstants.swift
//  
//
//  Created by Daniel Crespo Duarte on 3/05/24.
//

struct NetworkConstants {
    enum APIClient {
        static let contentType = "Content-Type"
        static let xApiKey = "X-API-Key"
        static let authorization = "Authorization"
        static let accept = "Accept"
        static let connection = "Connection"
    }
    
    enum InnerConstants {
        static let applicationJson = "application/json"
        static let accept = "*/*"
        static let keepAlive = "keep-alive"
        static let bearer = "Bearer %@"
    }
}
