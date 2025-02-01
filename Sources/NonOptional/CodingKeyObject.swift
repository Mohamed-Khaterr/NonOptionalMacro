//
//  CodingKeyObject.swift
//
//
//  Created by Mohamed Khater on 29/01/2025.
//

import Foundation

public struct CodingKeyObject: CodingKey {
    public var stringValue: String
    public var intValue: Int?
    
    public init(_ stringValue: String) {
        self.stringValue = stringValue
    }
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    public init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
