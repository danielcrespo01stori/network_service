//
//  APIModelMock.swift
//
//
//  Created by Daniel Crespo Duarte on 3/05/24.
//

import Foundation

struct APIModelMock: Codable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
