//
//  URL+Extensions.swift
//
//
//  Created by Daniel Crespo Duarte on 3/05/24.
//

import Foundation

extension URL {
    static func getUrl(from string: String?) -> URL? {
        return URL(string: string ?? "")
    }
}
