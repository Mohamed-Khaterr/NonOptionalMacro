//
//  Products.swift
//  Example
//
//  Created by Mohamed Khater on 29/01/2025.
//

import Foundation
import NonOptional

@NonOptional
struct Products: Decodable {
    let products: [Product]
}
