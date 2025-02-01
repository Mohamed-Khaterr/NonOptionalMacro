//
//  NonOptionalMacro.swift
//
//
//  Created by Mohamed Khater on 29/01/2025.
//

/// A macro that ensures all properties in a `struct` or `class`
/// are non-optional while automatically handling decoding logic.
///
/// ## Overview
/// The `@NonOptional` macro enforces that all properties are declared without optional types,
/// while internally managing decoding using an extension.
///
/// This macro applies only to `struct` and `class` types that conform to `Decodable`.
///
/// ## Functionality
/// - Ensures all properties are non-optional at the declaration site.
/// - Automatically generates a custom `init(from decoder:)` to handle optional decoding.
/// - Uses `decodeIfPresent` to extract optional values and assigns them safely.
///
/// ## Constraints
/// - Can only be applied to `struct` and `class`.
/// - Works with properties that are `Decodable`.
///
/// ## Example
/// ```swift
/// @NonOptional struct User: Codable {
///     let name: String
///     let age: Int
///     let email: String
///     let phoneNumber: String
/// }
/// ```
///
/// ## Generated Code
/// ```swift
/// extension User {
///     init(from decoder: any Decoder) throws {
///         let container = try decoder.container(keyedBy: CodingKeyObject.self);
///         let nameOptional = try container.decodeIfPresent(String.self,  forKey: CodingKeyObject("name"));
///         self.name = nameOptional.wrappedValue;
///         let ageOptional = try container.decodeIfPresent(Int.self,  forKey: CodingKeyObject("age"));
///         self.age = ageOptional.wrappedValue;
///         let emailOptional = try container.decodeIfPresent(String.self,  forKey: CodingKeyObject("email"));
///         self.email = emailOptional.wrappedValue;
///         let phoneNumberOptional = try container.decodeIfPresent(String.self,  forKey: CodingKeyObject("phoneNumber"));
///         self.phoneNumber = phoneNumberOptional.wrappedValue;
///     }
/// }
/// ```
///
/// By using `@NonOptional`, developers can define properties without explicitly marking them as optional,
/// while the macro ensures safe decoding.
@attached(extension, names: arbitrary)
public macro NonOptional() = #externalMacro(module: "NonOptionalMacros", type: "NonOptionalInitializer")
