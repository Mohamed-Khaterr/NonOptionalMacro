//
//  MetaData.swift
//  Example
//
//  Created by Mohamed Khater on 29/01/2025.
//

import Foundation
import NonOptional

@NonOptional
struct MetaData: Codable {
    let createdAt: String?
    let updatedAt: String?
    let barcode: String
    let QRCode: String?

    enum MetaDataCodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case barcode = "barcode"
        case QRCode = "qrCode"
    }
}
