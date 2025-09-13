import Foundation

public protocol RequestAdapter {
    func adapt(_ request: URLRequest, requiresAuth: Bool) async throws -> URLRequest
}

public protocol ResponseMiddleware {
    func inspect(request: URLRequest, response: HTTPURLResponse, data: Data) async throws
}
