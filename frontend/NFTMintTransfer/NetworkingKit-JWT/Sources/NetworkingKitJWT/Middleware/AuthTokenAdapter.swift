import Foundation

public struct AuthTokenAdapter: RequestAdapter {
    public let tokenProvider: () -> String?
    public init(tokenProvider: @escaping () -> String?) { self.tokenProvider = tokenProvider }
    public func adapt(_ request: URLRequest, requiresAuth: Bool) async throws -> URLRequest {
        guard requiresAuth, let token = tokenProvider() else { return request }
        var r = request
        r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return r
    }
}
