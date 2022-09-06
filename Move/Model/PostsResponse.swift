//// This file was generated from JSON Schema using quicktype, do not modify it directly.
//// To parse the JSON, add this file to your project and do:
////
////   let postsResponse = try? newJSONDecoder().decode(PostsResponse.self, from: jsonData)
//
//import Foundation
//
//
//
//// MARK: - PostResponseElement
//struct PostResponseElement: Codable {
//    let id: Int
//    let title, content: String?
//    let user: UserClass?
//    let publishedAt, createdAt, updatedAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case title
//        case content
//        case user
//        case publishedAt
//        case createdAt
//        case updatedAt
//    }
//}
//
//// MARK: - User
//struct UserClass: Codable {
//    let id: Int
//    let username, email, provider: String
//    let confirmed, blocked: Bool
//    let role: Int
//    let createdAt, updatedAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, username, email, provider, confirmed, blocked, role
//        case createdAt
//        case updatedAt
//    }
//}
//
//typealias PostsResponse = [PostResponseElement]
//
//
//
// MARK: - WriteResponse
struct WriteResponse: Codable {
    let id: Int
    let title, content: String
    let user: UserClass
    let publishedAt, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case user
        case publishedAt
        case createdAt
        case updatedAt
    }
}


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let postsResponse = try? newJSONDecoder().decode(PostsResponse.self, from: jsonData)

import Foundation

// MARK: - PostsResponseElement
struct PostsResponseElement: Codable {
    let id: Int
    let title, content: String?
    let user: UserClass?
    let published_at, created_at, updated_at: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case user
        case published_at
        case created_at
        case updated_at
    }
}

// MARK: - User
struct UserClass: Codable {
    let id: Int
    let username, email, provider: String
    let confirmed, blocked: Bool
    let role: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, username, email, provider, confirmed, blocked, role
        case createdAt
        case updatedAt
    }
}

typealias PostsResponse = [PostsResponseElement]
