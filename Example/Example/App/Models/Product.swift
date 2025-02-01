//
//  Product.swift
//  Example
//
//  Created by Mohamed Khater on 29/01/2025.
//

import Foundation
import NonOptional

@NonOptional
struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double?
    let stock: Int
    let tags: [String]
    let brand: String
    let sku: String
    let weight: Int
    let dimensions: Dimensions
    let warrantyInformation: String
    let shippingInformation: String
    let availabilityStatus: String
    let reviews: [Review]
    let returnPolicy: String
    let minimumOrderQuantity: Int
    let meta: MetaData
    let thumbnail: String
    let images: [String]
    
    enum ProductCodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case description = "description"
        case category = "category"
        case price = "price"
        case discountPercentage = "discountPercentage"
        case rating = "rating"
        case stock = "stock"
        case tags = "tags"
        case brand = "brand"
        case sku = "sku"
        case weight = "weight"
        case dimensions = "dimensions"
        case warrantyInformation = "warrantyInformation"
        case shippingInformation = "shippingInformation"
        case availabilityStatus = "availabilityStatus"
        case reviews = "reviews"
        case returnPolicy = "returnPolicy"
        case minimumOrderQuantity = "minimumOrderQuantity"
        case meta = "meta"
        case thumbnail = "thumbnail"
        case images = "images"
    }
    
    var imageURL: URL? {
        guard let firstImageURLString = images.first else { return nil }
        return URL(string: firstImageURLString)
    }
}
