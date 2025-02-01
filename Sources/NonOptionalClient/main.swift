import NonOptional

@NonOptional struct User: Codable {
    let name: String
    let age: Int
    let email: String
    let phoneNumber: String
}
