//
//  Review.swift
//  Example
//
//  Created by Mohamed Khater on 29/01/2025.
//

import Foundation
import NonOptional

@NonOptional
struct Review: Codable {
    let rating: Int
    let comment: String
    let date: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case rating = "rating"
        case comment = "comment"
        case date = "date"
        case name = "reviewerName"
        case email = "reviewerEmail"
    }
}
