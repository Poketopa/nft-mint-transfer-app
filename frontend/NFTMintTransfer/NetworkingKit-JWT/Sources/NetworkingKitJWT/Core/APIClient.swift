import Foundation

public protocol APIClientProtocol {
    func send<E: Endpoint>(_ endpoint: E) async throws -> E.Response
}

public final class APIClient: APIClientProtocol {
    private let session: URLSession
    private let config: NetworkConfig
    private let requestAdapters: [RequestAdapter]
    private let responseMiddlewares: [ResponseMiddleware]
    private let decoder: JSONDecoder

    public init(config: NetworkConfig,
                session: URLSession = .shared,
                requestAdapters: [RequestAdapter] = [],
                responseMiddlewares: [ResponseMiddleware] = [],
                decoder: JSONDecoder = .presetRFC3339SnakeCase) {
        self.config = config
        self.session = session
        self.requestAdapters = requestAdapters
        self.responseMiddlewares = responseMiddlewares
        self.decoder = decoder
    }

    public func send<E: Endpoint>(_ endpoint: E) async throws -> E.Response {
        var url = config.baseURL
        url.append(path: endpoint.path)
        guard var comps = URLComponents(url: url, resolvingAgainstBaseURL: false) else { throw NetworkError.invalidURL }
        comps.queryItems = endpoint.query
        guard let finalURL = comps.url else { throw NetworkError.invalidURL }

        var req = URLRequest(url: finalURL)
        req.httpMethod = endpoint.method.rawValue
        req.timeoutInterval = config.timeout
        var allHeaders = config.defaultHeaders
        endpoint.headers?.forEach { allHeaders[$0.key] = $0.value }
        req.allHTTPHeaderFields = allHeaders

        if let enc = endpoint.body {
            req.httpBody = try JSONEncoder().encode(AnyEncodable(enc))
            if req.value(forHTTPHeaderField: "Content-Type") == nil {
                req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }

        for adapter in requestAdapters {
            req = try await adapter.adapt(req, requiresAuth: endpoint.requiresAuth)
        }

        do {
            let (data, res) = try await session.data(for: req)
            guard let http = res as? HTTPURLResponse else { throw NetworkError.transport(URLError(.badServerResponse)) }

            for mw in responseMiddlewares {
                try await mw.inspect(request: req, response: http, data: data)
            }

            guard 200..<300 ~= http.statusCode else {
                if http.statusCode == 401 { throw NetworkError.unauthorized }
                throw NetworkError.server(status: http.statusCode, data: data)
            }
            do { return try decoder.decode(E.Response.self, from: data) }
            catch { throw NetworkError.decoding(error, data) }
        } catch let e as URLError {
            throw NetworkError.transport(e)
        } catch { throw error }
    }
}
