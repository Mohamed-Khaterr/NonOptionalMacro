//
//  Decodable+Extension.swift
//
//
//  Created by Mohamed Khater on 29/01/2025.
//

import Foundation

extension Decodable {
    static var empty: Self {
        if let objc = try? JSONDecoder().decode(Self.self, from: Data("{}".utf8)) {
            return objc
        } else {
            return try! JSONDecoder().decode(Self.self, from: Data("[]".utf8))
        }
    }
}
