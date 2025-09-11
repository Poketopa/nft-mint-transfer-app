import Foundation

public enum HTTPMethod: String { case GET, POST, PUT, PATCH, DELETE }

public protocol Endpoint {
    associatedtype Response: Decodable
    var path: String { get }
    var method: HTTPMethod { get }
    var query: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var body: Encodable? { get }
    var requiresAuth: Bool { get }
}

public struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    public init(_ wrapped: Encodable) { self._encode = wrapped.encode }
    public func encode(to encoder: Encoder) throws { try _encode(encoder) }
}
