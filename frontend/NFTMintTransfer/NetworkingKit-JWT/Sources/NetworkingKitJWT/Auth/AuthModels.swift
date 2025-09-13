import Foundation

public struct UserDTO: Codable, Hashable {
    public let id: String
    public let email: String
    public let nickname: String
    public init(id: String, email: String, nickname: String) { 
        self.id = id
        self.email = email
        self.nickname = nickname
    }
}

public struct LoginRequestDTO: Encodable {
    public let email: String
    public let password: String
    public init(email: String, password: String) { self.email = email; self.password = password }
}

public struct LoginResponseDTO: Decodable {
    public let accessToken: String
}

public struct SignupRequestDTO: Encodable {
    public let email: String
    public let nickname: String
    public let password: String
    public init(email: String, nickname: String, password: String) { 
        self.email = email
        self.nickname = nickname
        self.password = password
    }
}

public struct SignupResponseDTO: Decodable {
    public let userId: Int
}
