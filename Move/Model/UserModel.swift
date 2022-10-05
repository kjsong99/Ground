//
//// This file was generated from JSON Schema using quicktype, do not modify it directly.
//// To parse the JSON, add this file to your project and do:
////
////   let registerResponse = try? newJSONDecoder().decode(RegisterResponse.self, from: jsonData)
//import Foundation
//
//// MARK: - RegisterResponse
//struct RegisterResponse: Codable {
//    let jwt: String
//    let user: RegisterUserClass
//}
//
//// MARK: - User
//struct RegisterUserClass: Codable {
//    let id: Int
//    let username, email, provider: String
//    let confirmed: Bool
//    let blocked: JSONNull?
//    let role: Role
//    let created_at, updated_at: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, username, email, provider, confirmed, blocked, role
//        case created_at
//        case updated_at
//    }
//}
//
//
//// MARK: - Role
//struct Role: Codable {
//    let id: Int
//    let name, description, type: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case description
//        case type
//    }
//}
//
//typealias UserResponse = [RegisterUserClass]
//
//// MARK: - Encode/decode helpers
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}

import Foundation
struct RegisterResponse: Codable {
    let jwt: String
    let user: UserResponseElement
}


// MARK: - UserResponseElement
struct UserResponseElement: Codable {
    let id: Int
    let username, email, provider: String
    let confirmed: Bool?
    let blocked: Bool?
    let role: Role
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, username, email, provider, confirmed, blocked, role
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Role
struct Role: Codable {
    let id: Int
    let name, roleDescription, type: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case roleDescription = "description"
        case type
    }
}

typealias UserResponse = Array<UserResponseElement>
