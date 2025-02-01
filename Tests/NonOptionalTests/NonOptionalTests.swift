//
//  NonOptionalTests.swift
//  
//
//  Created by Mohamed Khater on 29/01/2025.
//

import SwiftSyntaxMacrosTestSupport
import NonOptionalMacros
import XCTest


final class NonOptionalTests: XCTestCase {
    func test_initialization() throws {
        assertMacroExpansion(
            """
            @NonOptional
            struct Response: Decodable {
                let name: String
                let age: Int
                
                enum CodingKeys: String, CodingKey {
                    case name
                    case age
                }
            }
            """,
            expandedSource: """
            
            struct Response: Decodable {
                let name: String
                let age: Int
                
                enum CodingKeys: String, CodingKey {
                    case name
                    case age
                }
            }
            
            extension Response {
                init(from decoder: any Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self);
                    let nameOptional = try container.decodeIfPresent(String.self,  forKey: .name);
                    self.name = nameOptional.wrappedValue;
                    let ageOptional = try container.decodeIfPresent(Int.self,  forKey: .age);
                    self.age = ageOptional.wrappedValue;
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_DecodableWithoutCodingKeys() {
        assertMacroExpansion(
            """
            @NonOptional
            struct Response: Decodable {
                let name: String
                let age: Int
            }
            """,
            expandedSource: """
            
            struct Response: Decodable {
                let name: String
                let age: Int
            }
            
            extension Response {
                init(from decoder: any Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeyObject.self);
                    let nameOptional = try container.decodeIfPresent(String.self,  forKey: CodingKeyObject("name"));
                    self.name = nameOptional.wrappedValue;
                    let ageOptional = try container.decodeIfPresent(Int.self,  forKey: CodingKeyObject("age"));
                    self.age = ageOptional.wrappedValue;
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_WithImplementedCodingKeys() {
        assertMacroExpansion(
            """
            @NonOptional
            struct Response: Decodable {
                let name: String
                let age: Int
                
                enum CodingKeys: String, CodingKey {
                    case name
                    case age
                }
            }
            """,
            expandedSource: """
            
            struct Response: Decodable {
                let name: String
                let age: Int
                
                enum CodingKeys: String, CodingKey {
                    case name
                    case age
                }
            }
            
            extension Response {
                init(from decoder: any Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self);
                    let nameOptional = try container.decodeIfPresent(String.self,  forKey: .name);
                    self.name = nameOptional.wrappedValue;
                    let ageOptional = try container.decodeIfPresent(Int.self,  forKey: .age);
                    self.age = ageOptional.wrappedValue;
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_WithImplementedCodingKeys_CustomCodingKeysName() {
        assertMacroExpansion(
            """
            @NonOptional
            struct Response: Decodable {
                let name: String
                let age: Int
                
                enum CodingKeysTest: String, CodingKey {
                    case name
                    case age
                }
            }
            """,
            expandedSource: """
            
            struct Response: Decodable {
                let name: String
                let age: Int
                
                enum CodingKeysTest: String, CodingKey {
                    case name
                    case age
                }
            }
            
            extension Response {
                init(from decoder: any Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeysTest.self);
                    let nameOptional = try container.decodeIfPresent(String.self,  forKey: .name);
                    self.name = nameOptional.wrappedValue;
                    let ageOptional = try container.decodeIfPresent(Int.self,  forKey: .age);
                    self.age = ageOptional.wrappedValue;
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_WithCodingKeyObject() {
        assertMacroExpansion(
            """
            @NonOptional
            struct Response: Decodable {
                let name: String
                let age: Int
            }
            """,
            expandedSource: """
            
            struct Response: Decodable {
                let name: String
                let age: Int
            }
            
            extension Response {
                init(from decoder: any Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeyObject.self);
                    let nameOptional = try container.decodeIfPresent(String.self,  forKey: CodingKeyObject("name"));
                    self.name = nameOptional.wrappedValue;
                    let ageOptional = try container.decodeIfPresent(Int.self,  forKey: CodingKeyObject("age"));
                    self.age = ageOptional.wrappedValue;
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_withComputedProperty() {
        assertMacroExpansion(
            """
            @NonOptional
            struct Response: Decodable {
                let name: String
                let age: Int
                
                var image: String {
                    ""
                }
            }
            """,
            expandedSource: """
            
            struct Response: Decodable {
                let name: String
                let age: Int
                
                var image: String {
                    ""
                }
            }
            
            extension Response {
                init(from decoder: any Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeyObject.self);
                    let nameOptional = try container.decodeIfPresent(String.self,  forKey: CodingKeyObject("name"));
                    self.name = nameOptional.wrappedValue;
                    let ageOptional = try container.decodeIfPresent(Int.self,  forKey: CodingKeyObject("age"));
                    self.age = ageOptional.wrappedValue;
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_withOptionalValue() throws {
        assertMacroExpansion(
            """
            @NonOptional
            struct Response: Decodable {
                let name: String
                let age: Int?
            }
            """,
            expandedSource: """
            
            struct Response: Decodable {
                let name: String
                let age: Int?
            }
            
            extension Response {
                init(from decoder: any Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeyObject.self);
                    let nameOptional = try container.decodeIfPresent(String.self,  forKey: CodingKeyObject("name"));
                    self.name = nameOptional.wrappedValue;
                    self.age = try container.decodeIfPresent(Int.self,  forKey: CodingKeyObject("age"));
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_withOptionalValue_withImplementedCodingKeys() throws {
        assertMacroExpansion(
            """
            @NonOptional
            struct Response: Decodable {
                let name: String
                let age: Int?
            
                enum CodingKeys: String, CodingKey {
                    case name
                    case age
                }
            }
            """,
            expandedSource: """
            
            struct Response: Decodable {
                let name: String
                let age: Int?
            
                enum CodingKeys: String, CodingKey {
                    case name
                    case age
                }
            }
            
            extension Response {
                init(from decoder: any Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self);
                    let nameOptional = try container.decodeIfPresent(String.self,  forKey: .name);
                    self.name = nameOptional.wrappedValue;
                    self.age = try container.decodeIfPresent(Int.self,  forKey: .age);
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_withOptionalValue_withImplementedCodingKeys_customCodingKeysName() throws {
        assertMacroExpansion(
            """
            @NonOptional
            struct Response: Decodable {
                let name: String
                let age: Int?
            
                enum CodingKeysTest: String, CodingKey {
                    case name
                    case age
                }
            }
            """,
            expandedSource: """
            
            struct Response: Decodable {
                let name: String
                let age: Int?
            
                enum CodingKeysTest: String, CodingKey {
                    case name
                    case age
                }
            }
            
            extension Response {
                init(from decoder: any Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeysTest.self);
                    let nameOptional = try container.decodeIfPresent(String.self,  forKey: .name);
                    self.name = nameOptional.wrappedValue;
                    self.age = try container.decodeIfPresent(Int.self,  forKey: .age);
                }
            }
            """,
            macros: testMacros
        )
    }
}
