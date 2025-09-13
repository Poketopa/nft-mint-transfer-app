import Foundation

/// 서버는 JSON으로 "JWT 토큰 문자열"을 내려준다.
/// 이 타입은 토큰을 가볍게 파싱/검사할 때만 쓰는 헬퍼이며 Codable이 필요 없다.
public struct JWT {
    public let header: [String: Any]
    public let payload: [String: Any]

    public init(header: [String: Any], payload: [String: Any]) {
        self.header = header
        self.payload = payload
    }

    /// exp(Unix epoch, 초)로 만료여부 판단
    public var exp: TimeInterval? { payload["exp"] as? TimeInterval }
    public var isExpired: Bool {
        guard let exp = exp else { return false }
        return Date().timeIntervalSince1970 >= exp
    }
}

/// Base64URL 디코딩으로 헤더/페이로드만 추출
public enum JWTDecoder {
    public static func decode(_ token: String) -> JWT? {
        let parts = token.split(separator: ".")
        guard parts.count >= 2 else { return nil }

        func decodePart(_ part: Substring) -> [String: Any]? {
            var s = String(part).replacingOccurrences(of: "-", with: "+")
                                 .replacingOccurrences(of: "_", with: "/")
            let pad = (4 - s.count % 4) % 4
            s.append(String(repeating: "=", count: pad))
            guard let data = Data(base64Encoded: s) else { return nil }
            return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
        }

        guard let h = decodePart(parts[0]), let p = decodePart(parts[1]) else { return nil }
        return JWT(header: h, payload: p)
    }
}
