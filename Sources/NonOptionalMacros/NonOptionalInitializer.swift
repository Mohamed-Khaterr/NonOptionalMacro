//
//  NonOptionalInitializer.swift
//
//
//  Created by Mohamed Khater on 29/01/2025.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct NonOptionalInitializer {
    // MARK: - Helper
    private static func getMembers(from declaration: some DeclGroupSyntax) throws -> MemberBlockItemListSyntax {
        let members: MemberBlockItemListSyntax
        if let structMembers = declaration.as(StructDeclSyntax.self)?.memberBlock.members {
            members = structMembers
        } else if let classMembers = declaration.as(ClassDeclSyntax.self)?.memberBlock.members {
            members = classMembers
        } else {
            throw CustomError.onlyApplicableToStructOrClass
        }
        return members
    }
    
    // Get all properties inside the struct or class
    private static func getVariables(from members: MemberBlockItemListSyntax) -> [(name: PatternSyntax, type: TypeSyntax, isOptional: Bool)] {
        let variablesDecl = members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
        let variables: [(name: PatternSyntax, type: TypeSyntax, isOptional: Bool)] = variablesDecl.compactMap {
            // Ignore Computed Property
            guard $0.bindings.first?.accessorBlock == nil else {
                return nil
            }
            
            if let name = $0.bindings.first?.pattern, let type = $0.bindings.first?.typeAnnotation?.type {
                let isOptional = type.is(OptionalTypeSyntax.self)
                return (name, type, isOptional)
            }
            return nil
        }
        
        return variables
    }
    
    // Get the enum name that implement CodingKey,
    // return nil if it's not implemented
    private static func getEnumCodingKeysName(from members: MemberBlockItemListSyntax) -> TokenSyntax? {
        let enumDecls = members.compactMap { $0.decl.as(EnumDeclSyntax.self) }
        
        for enumDecl in enumDecls {
            let codingKeyEnum = enumDecl
                .inheritanceClause?
                .inheritedTypes
                .compactMap({ $0.type.as(IdentifierTypeSyntax.self) })
                .contains(where: { $0?.name.text == "CodingKey" })
            
            if codingKeyEnum == true {
                return enumDecl.name
            }
        }
        
        return nil
    }
    
    // Will generate the decoding init and set all self properties
    // by using CodingKeyObject
    private static func generateInitializerWithCustomCodingKey(with variables: [(name: PatternSyntax, type: TypeSyntax, isOptional: Bool)]) throws -> InitializerDeclSyntax {
        try InitializerDeclSyntax("init(from decoder: any Decoder) throws") {
            DeclSyntax("let container = try decoder.container(keyedBy: CodingKeyObject.self);")
            
            for (name, type, isOptional) in variables {
                if isOptional {
                    let newType = type.as(OptionalTypeSyntax.self)!.wrappedType.as(IdentifierTypeSyntax.self)!.name
                    DeclSyntax("\n        self.\(name) = try container.decodeIfPresent(\(newType).self,  forKey: CodingKeyObject(\"\(name)\"));")
                } else {
                    DeclSyntax("let \(name)Optional = try container.decodeIfPresent(\(type).self,  forKey: CodingKeyObject(\"\(name)\"));")
                    DeclSyntax("\n        self.\(name) = \(name)Optional.wrappedValue;")
                }
            }
        }
    }
    
    // Will generate the decoding init and set all self properties
    // by using CodingKey that defined in the struct or class
    private static func generateInitializerWithDefaultCodingKey(with variables: [(name: PatternSyntax, type: TypeSyntax, isOptional: Bool)], codingKeyEnumName: TokenSyntax) throws -> InitializerDeclSyntax {
        try InitializerDeclSyntax("init(from decoder: any Decoder) throws") {
            DeclSyntax("let container = try decoder.container(keyedBy: \(codingKeyEnumName).self);")
            for (name, type, isOptional) in variables {
                if isOptional {
                    let newType = type.as(OptionalTypeSyntax.self)!.wrappedType.as(IdentifierTypeSyntax.self)!.name
                    DeclSyntax("\n        self.\(name) = try container.decodeIfPresent(\(newType).self,  forKey: .\(name));")
                } else {
                    DeclSyntax("let \(name)Optional = try container.decodeIfPresent(\(type).self,  forKey: .\(name));\n")
                    DeclSyntax("\n        self.\(name) = \(name)Optional.wrappedValue;")
                }
            }
        }
    }
    
    private static func getAccessControl(from declaration: some DeclGroupSyntax) -> TokenSyntax? {
        var foundedTokenSyntax: TokenSyntax?
        if let structDecl = declaration.as(StructDeclSyntax.self) {
            for modifier in structDecl.modifiers {
                if case .keyword(let keyword) = modifier.name.tokenKind {
                    switch keyword {
                    case .public, .private, .fileprivate, .internal, .open:
                        foundedTokenSyntax = modifier.name
                    default:
                        continue
                    }
                }
            }
        } else if let classDecl = declaration.as(ClassDeclSyntax.self) {
            for modifier in classDecl.modifiers {
                if case .keyword(let keyword) = modifier.name.tokenKind {
                    switch keyword {
                    case .public, .private, .fileprivate, .internal, .open:
                        foundedTokenSyntax = modifier.name
                    default:
                        continue
                    }
                }
            }
        } else if let enumDecl = declaration.as(EnumDeclSyntax.self) {
            for modifier in enumDecl.modifiers {
                if case .keyword(let keyword) = modifier.name.tokenKind {
                    switch keyword {
                    case .public, .private, .fileprivate, .internal, .open:
                        foundedTokenSyntax = modifier.name
                    default:
                        continue
                    }
                }
            }
        }
        
        return foundedTokenSyntax
    }
}

// MARK: - Implementation
extension NonOptionalInitializer: ExtensionMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol, conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        let members = try getMembers(from: declaration)
        let variables = getVariables(from: members)
        let customCodingKeyEnumName = getEnumCodingKeysName(from: members)
        
        let initializer: InitializerDeclSyntax
        
        if let customCodingKeyEnumName = customCodingKeyEnumName {
            initializer = try generateInitializerWithDefaultCodingKey(with: variables, codingKeyEnumName: customCodingKeyEnumName)
        } else {
            initializer = try generateInitializerWithCustomCodingKey(with: variables)
        }
        
        let extensionDecl: ExtensionDeclSyntax
        if let accessControl = getAccessControl(from: declaration) {
            extensionDecl = try ExtensionDeclSyntax("\(accessControl)extension \(type.trimmed)") {
                initializer
            }
        } else {
            extensionDecl = try ExtensionDeclSyntax("extension \(type.trimmed)") {
                initializer
            }
        }
        
        return [extensionDecl]
    }
}
