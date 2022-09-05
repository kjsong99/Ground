// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let postsResponse = try? newJSONDecoder().decode(PostsResponse.self, from: jsonData)

import Foundation

// MARK: - PostsResponse
struct PostsResponse: Decodable {
    let data: [Datum]
    let meta: Meta
}

struct WriteResponse: Decodable {
    let data: Datum
    let meta: Meta
}

// MARK: - UserClass
struct UserClass: Codable {
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let id: Int
    let attributes: DataAttributes
}

// MARK: - DataAttributes
struct DataAttributes: Codable {
    let username, email, provider: String
    let confirmed, blocked: Bool
    let createdAt, updatedAt: String
    
}



// MARK: - Datum
struct Datum: Decodable {
    let id: Int
    let attributes: Attributes
}

// MARK: - Attributes
struct Attributes: Codable {
    let Title, Content, createdAt, updatedAt: String
    let publishedAt: String
    let user: UserClass

    enum CodingKeys: String, CodingKey {
        case Title
        case Content
        case createdAt, updatedAt, publishedAt
        case user
    }
}



// MARK: - Meta
struct Meta: Codable {
    let pagination: Pagination
}

// MARK: - Pagination
struct Pagination: Codable {
    let page, pageSize, pageCount, total: Int
}
