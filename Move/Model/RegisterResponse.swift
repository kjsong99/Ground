import Foundation

// MARK: - RegisterResponse
struct RegisterResponse: Codable {
    let jwt: String
    let user: User
}

// MARK: - User
struct User: Codable {
    let id: Int
    let username, email, provider: String
    let confirmed, blocked: Bool
    let createdAt, updatedAt: String
}
