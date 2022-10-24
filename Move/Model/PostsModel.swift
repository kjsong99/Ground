import Foundation

struct PostClass: Codable {
    let id: Int
    let title, content: String
    let user: UserClass
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, title, content, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

typealias PostsResponse = [PostClass]
