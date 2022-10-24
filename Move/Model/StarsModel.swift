import Foundation

// MARK: - HeartModelElement
struct StarResponseElement: Codable {
    let id: Int
    let post: PostClass
    let user: UserClass
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, post, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

typealias StarResponse = [StarResponseElement]
