//
//  HeartsModel.swift
//  Move
//
//  Created by 송경진 on 2022/10/05.
//
//
//import Foundation
//
//struct HeartsResponseElement : Codable{
//    let id: Int
//    let post : HeartPost?
//    let user : HeartUser?
//    let created_at, updated_at: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case post
//        case user
//        case created_at
//        case updated_at
//    }
//}
//
//typealias HeartsResponse = [HeartsResponseElement]


import Foundation

// MARK: - HeartModelElement
struct StarResponseElement: Codable {
    let id: Int
    let post: StarPost?
    let user: StarUser?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, post, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
//
//// MARK: - Post
struct StarPost: Codable {
    let id: Int?
    let title, content: String?
    let user: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, content, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - User
struct StarUser: Codable {
    let id: Int?
    let username, email, provider: String?
    let confirmed: Bool?
    let blocked: Bool?
    let role: Int?
    let createdAt, updatedAt: String?
    let gender: String?
    let birth : String?

    enum CodingKeys: String, CodingKey {
        case id, username, email, provider, confirmed, blocked, role, gender, birth
        case createdAt = "created_at"
        case updatedAt = "updated_at"

    }
}

//// MARK: - User
//struct HeartUser: Codable {
//    let id: Int?
//    let username, email, provider: String?
//    let confirmed: Bool?
//    let blocked: Bool?
//    let role: Int?
//    let createdAt, updatedAt: String?
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

typealias StarResponse = [StarResponseElement]
