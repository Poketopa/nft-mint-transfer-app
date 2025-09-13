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

public struct MultipartFile {
    public let data: Data
    public let filename: String
    public let mimeType: String
    
    public init(data: Data, filename: String, mimeType: String) {
        self.data = data
        self.filename = filename
        self.mimeType = mimeType
    }
}

public struct MultipartFormData: Encodable {
    public let fields: [String: Encodable]
    public let files: [String: MultipartFile]
    
    public init(fields: [String: Encodable], files: [String: MultipartFile]) {
        self.fields = fields
        self.files = files
    }
    
    public func encode(to encoder: Encoder) throws {
        // multipart/form-data는 별도로 처리되므로 기본 JSON 인코딩은 사용하지 않음
        var container = encoder.singleValueContainer()
        try container.encode("multipart/form-data")
    }
}

