//
//  ObjectType.swift
//
//
//  Created by Mohamed Khater on 30/01/2025.
//

import Foundation
import SwiftSyntax

enum ObjectType {
    case `class`
    case `struct`
    case `enum`
    case unknown
    
    init(_ declaration: some DeclGroupSyntax) {
        self = switch declaration {
        case is ClassDeclSyntax: .class
        case is StructDeclSyntax: .struct
        case is EnumDeclSyntax: .enum
        default: .unknown
        }
    }
}
