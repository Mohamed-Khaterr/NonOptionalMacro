//
//  TestMacros.swift
//  
//
//  Created by Mohamed Khater on 29/01/2025.
//

import SwiftSyntaxMacros
import NonOptionalMacros

let testMacros: [String: Macro.Type] = [
    "NonOptional": NonOptionalInitializer.self,
]
