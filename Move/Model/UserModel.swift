import Foundation

struct RegisterResponse: Codable {
    let jwt: String
    let user: User
}


//user 조회시 사용되는 user class
struct User: Codable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    let username, email, provider: String
    let confirmed: Bool?
    let blocked: Bool?
    let role: Role?
    let createdAt, updatedAt: String
    let birth, gender: String?

    enum CodingKeys: String, CodingKey {
        case id, username, email, provider, confirmed, blocked, role
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case birth, gender
    }
}

// relation 사용시 가져오는 user class
struct UserCompact: Codable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
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



struct Role: Codable, Equatable{
    let id: Int
    let name, roleDescription, type: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case roleDescription = "description"
        case type
    }
}

typealias UserResponse = Array<User>
