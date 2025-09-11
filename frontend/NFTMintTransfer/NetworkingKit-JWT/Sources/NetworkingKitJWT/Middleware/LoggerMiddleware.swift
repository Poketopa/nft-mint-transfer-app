import Foundation

public struct LoggerMiddleware: ResponseMiddleware {
    public init() {}
    public func inspect(request: URLRequest, response: HTTPURLResponse, data: Data) async throws {
        #if DEBUG
        print("➡️", request.httpMethod ?? "?", request.url?.absoluteString ?? "?")
        print("⬅️ [\(response.statusCode)] bytes=\(data.count)")
        #endif
    }
}
