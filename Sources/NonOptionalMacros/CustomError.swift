//
//  CustomError.swift
//  
//
//  Created by Mohamed Khater on 29/01/2025.
//

import Foundation

enum CustomError: CustomStringConvertible, Error {
    case onlyApplicableToStructOrClass
    case message(String)
    
    var description: String {
        switch self {
        case .onlyApplicableToStructOrClass: "@NetworkResponse macro can only be applied to 'struct' or 'class'"
        case .message(let message): message
        }
    }
}
