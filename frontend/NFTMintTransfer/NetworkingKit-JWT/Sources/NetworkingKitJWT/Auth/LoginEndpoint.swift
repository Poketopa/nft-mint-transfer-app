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
