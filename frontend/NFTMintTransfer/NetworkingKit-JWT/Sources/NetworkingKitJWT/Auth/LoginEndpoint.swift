import Foundation

public struct LoginEndpoint: Endpoint {
    public typealias Response = LoginResponseDTO
    public let email: String
    public let password: String
    public init(email: String, password: String) { self.email = email; self.password = password }
    public var path: String { "/auth/login" }
    public var method: HTTPMethod { .POST }
    public var query: [URLQueryItem]? { nil }
    public var headers: [String : String]? { ["Content-Type": "application/json"] }
    public var body: Encodable? { LoginRequestDTO(email: email, password: password) }
    public var requiresAuth: Bool { false }
}

public struct SignupEndpoint: Endpoint {
    public typealias Response = SignupResponseDTO
    public let email: String
    public let nickname: String
    public let password: String
    public let profileImage: Data?
    
    public init(email: String, nickname: String, password: String, profileImage: Data? = nil) { 
        self.email = email
        self.nickname = nickname
        self.password = password
        self.profileImage = profileImage
    }
    
    public var path: String { "/auth/signup" }
    public var method: HTTPMethod { .POST }
    public var query: [URLQueryItem]? { nil }
    public var headers: [String : String]? { nil } // multipart/form-data는 boundary가 자동으로 설정됨
    public var body: Encodable? { 
        MultipartFormData(
            fields: [
                "request": SignupRequestDTO(email: email, nickname: nickname, password: password)
            ],
            files: profileImage != nil ? [
                "profileImage": MultipartFile(
                    data: profileImage!,
                    filename: "profile.jpg",
                    mimeType: "image/jpeg"
                )
            ] : [:]
        )
    }
    public var requiresAuth: Bool { false }
}