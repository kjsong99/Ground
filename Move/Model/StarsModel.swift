import Foundation

// MARK: - HeartModelElement
struct StarResponseElement: Codable {
    let id: Int
    let post: PostCompact
    let user: UserCompact
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, post, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    
}

typealias StarResponse = [StarResponseElement]
