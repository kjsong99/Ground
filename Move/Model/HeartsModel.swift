import Foundation

// MARK: - HeartModelElement
struct HeartResponseElement: Codable {
    let id: Int
    let post: HeartPost?
    let user: UserClass
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, post, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
//
// MARK: - Post
struct HeartPost: Codable {
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
struct HeartUser: Codable {
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

typealias HeartResponse = [HeartResponseElement]
