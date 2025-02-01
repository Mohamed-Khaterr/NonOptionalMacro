# @NonOptional Macro
![Swift: Version](https://img.shields.io/badge/Swift-5.10-lightgray?logo=Swift)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/Mohamed-Khaterr/NonOptionalMacro/blob/main/LICENSE.txt)
![iOS: Version](https://img.shields.io/badge/iOS-13.0+-blue)
![macOS: Version](https://img.shields.io/badge/macOS-10.15+-bule)
![tvOS: Version](https://img.shields.io/badge/tvOS-13.0+-bule)
![watchOS: Version](https://img.shields.io/badge/watchOS-16.0+-blue)

A Swift macro that allows properties in a `struct` or `class` to be non-optional while automatically handling decoding logic when values are missing in JSON or XML.

## Table of Content
- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Example Project](#example-project)
- [Contribution](#contributing)
- [License](#license)

## Overview
The `@NonOptional` macro permits properties to be declared without optional types, while internally managing decoding using an extension.

This macro applies only to `struct` and `class` types that conform to `Codable`.

## Features
- Allows properties to be **non-optional** while handling missing values gracefully.
- Automatically generates a custom `init(from decoder:)` to handle optional decoding.
- Extract optional values and assigns them safely.

## Installation
To use this macro in your Swift project, follow these steps:

### Swift Package Manager:
```swift
dependencies: [
    .package(url: "https://github.com/Mohamed-Khaterr/NonOptionalMacro.git", from: "1.0.0")
]
```
   

## Usage
Import the macro in your Swift file:
```swift
import NonOptional
```
Annotate `Decodable` struct or class with `@NonOptional`
```swift
@NonOptional struct User: Codable {
    let name: String
    let age: Int
}

// Generated Code
extension User {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeyObject.self);
        let nameOptional = try container.decodeIfPresent(String.self,  forKey: CodingKeyObject("name"));
        self.name = nameOptional.wrappedValue;
        let ageOptional = try container.decodeIfPresent(Int.self,  forKey: CodingKeyObject("age"));
        self.age = ageOptional.wrappedValue;
    }
}
```

By using `@NonOptional`, you can define properties without explicitly marking them as `Optional`, while the macro ensures safe decoding when values are absent in JSON or XML.

You can also define a specific property as `Optional` with custom `CodingKey`.
```swift
@NonOptional struct User: Codable {
    let name: String
    let age: Int
    let email: String?

    enum CustomCodingKeys: String, CodingKey {
        case name = "user_name"
        case age = "user_age"
        case email = "user_email"
    }
}

// Generated Code
extension User {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self);
        let nameOptional = try container.decodeIfPresent(String.self,  forKey: .name);
        self.name = nameOptional.wrappedValue;
        let ageOptional = try container.decodeIfPresent(Int.self,  forKey: .age);
        self.age = ageOptional.wrappedValue;
        self.email = try container.decodeIfPresent(String.self, forKey: .email);
    }
}
```

## Example project
For better understanding, I recommend that you take a look at the example project located in the `Example` folder.

## Contributing
Contributions are welcome to help improve and grow this project!

### Reporting bugs

If you come across a bug, kindly open an issue on GitHub, providing a detailed description of the problem. 
Include the following information:

- steps to reproduce the bug
- expected behavior
- actual behavior
- environment details (Swift version, etc.)

### Requesting features

For feature requests, please open an issue on GitHub. Clearly describe the new functionality you'd like to see and provide any relevant details or use cases.

### Submitting pull requests

To submit a pull request:
1. Fork the repository.
2. Create a new branch for your changes.
3. Make your changes and test thoroughly.
4. Open a pull request, clearly describing the changes you've made.

Thank you for contributing to SwiftUICoordinator! 🚀

**If you appreciate this project, kindly give it a ⭐️ to help others discover the repository.**

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/Mohamed-Khaterr/NonOptionalMacro/blob/main/LICENSE.txt) file for details.