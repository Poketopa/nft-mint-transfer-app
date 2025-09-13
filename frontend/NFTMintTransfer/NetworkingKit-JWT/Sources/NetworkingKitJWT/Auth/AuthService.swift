import Foundation

public protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> UserDTO
    func signup(email: String, nickname: String, password: String, profileImage: Data?) async throws -> UserDTO
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
        // JWT에서 사용자 정보 추출 (실제로는 JWT를 디코딩해서 사용자 정보를 가져와야 함)
        // 여기서는 간단히 이메일만 사용
        return UserDTO(id: "temp", email: email, nickname: "")
    }

    public func signup(email: String, nickname: String, password: String, profileImage: Data?) async throws -> UserDTO {
        let res: SignupResponseDTO = try await client.send(SignupEndpoint(email: email, nickname: nickname, password: password, profileImage: profileImage))
        // 회원가입은 userId만 반환하므로 UserDTO 생성
        return UserDTO(id: String(res.userId), email: email, nickname: nickname)
    }

    public func currentJWT() -> JWT? {
        guard let token = tokenStore.loadAccessToken() else { return nil }
        return JWTDecoder.decode(token)
    }

    public func logout() { tokenStore.removeAccessToken() }
}
