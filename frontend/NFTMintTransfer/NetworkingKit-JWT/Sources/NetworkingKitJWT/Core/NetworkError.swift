import Foundation

public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case transport(URLError)
    case server(status: Int, data: Data?)
    case decoding(Error, Data)
    case unauthorized
    case tokenExpired

    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "잘못된 URL"
        case .transport(let e): return "네트워크 전송 오류: \(e.localizedDescription)"
        case .server(let status, let data):
            let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
            return "서버 오류(\(status)): \(body)"
        case .decoding(_, _): return "응답 파싱 실패"
        case .unauthorized: return "인증 필요 또는 자격 증명 오류"
        case .tokenExpired: return "토큰 만료"
        }
    }
}
