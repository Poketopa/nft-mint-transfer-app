import Foundation

public struct UserDTO: Codable, Hashable {
    public let id: String
    public let email: String
    public init(id: String, email: String) { self.id = id; self.email = email }
}

public struct LoginRequestDTO: Encodable {
    public let email: String
    public let password: String
    public init(email: String, password: String) { self.email = email; self.password = password }
}

public struct LoginResponseDTO: Decodable {
    public let accessToken: String
    public let user: UserDTO
}
