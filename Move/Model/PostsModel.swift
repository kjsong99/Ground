//import Foundation
//
//// MARK: - WriteResponse
struct WriteResponse: Codable {
    let id: Int
    let title, content: String
    let user: PostUser?
    let created_at, updated_at: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case user
        case created_at
        case updated_at
    }
}
//
//
//// This file was generated from JSON Schema using quicktype, do not modify it directly.
//// To parse the JSON, add this file to your project and do:
////
////   let postsResponse = try? newJSONDecoder().decode(PostsResponse.self, from: jsonData)
//
//
//
//// MARK: - PostsResponseElement
//struct PostsResponseElement: Codable{
//
//    let id: Int?
//    let title, content: String
//    let user: UserClass?
//    let createdAt, updateAt: String
//
//
//    enum CodingKeys: String, CodingKey {
//        case id, title, content, user
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
//
//// MARK: - User
//struct UserClass: Codable {
//    let id: Int
//    let username, email, provider: String
//    let confirmed, blocked: Bool?
//    let role: Int
//    let createdAt, updateAt: String
//    let gender: String?
//    let birth : String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, username, email, provider, confirmed, blocked, role, gender, birth
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//
//    }
//}
//
//typealias PostsResponse = [PostsResponseElement]

import Foundation

// MARK: - PostsResponseElement
struct PostsResponseElement: Codable {
    let id: Int
    let title, content: String
    let user: PostUser?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, title, content, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - User
struct PostUser: Codable {
    let id: Int
    let username, email, provider: String
    let confirmed: Bool?
    let blocked: Bool?
    let role: Int?
    let createdAt, updatedAt: String
    let birth, gender: String?

    enum CodingKeys: String, CodingKey {
        case id, username, email, provider, confirmed, blocked, role
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case birth, gender
    }
}

typealias PostsResponse = [PostsResponseElement]
