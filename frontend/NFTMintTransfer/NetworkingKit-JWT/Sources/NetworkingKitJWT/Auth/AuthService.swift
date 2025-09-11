import Foundation

public protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> UserDTO
    func currentJWT() -> JWT?
    func logout()
}

public final class AuthService: AuthServiceProtocol {
    private let client: APIClientProtocol
    private let tokenStore: TokenStore

    public init(client: APIClientProtocol, tokenStore: TokenStore) {
        self.client = client
        self.tokenStore = tokenStore
    }

    public func login(email: String, password: String) async throws -> UserDTO {
        let res: LoginResponseDTO = try await client.send(LoginEndpoint(email: email, password: password))
        try tokenStore.saveAccessToken(res.accessToken)
        return res.user
    }

    public func currentJWT() -> JWT? {
        guard let token = tokenStore.loadAccessToken() else { return nil }
        return JWTDecoder.decode(token)
    }

    public func logout() { tokenStore.removeAccessToken() }
}
