import Foundation

public enum Environment { case dev, stage, prod }

public struct NetworkConfig {
    public let baseURL: URL
    public let defaultHeaders: [String: String]
    public let timeout: TimeInterval
    public let environment: Environment

    public init(baseURL: URL,
                defaultHeaders: [String: String] = ["Accept": "application/json"],
                timeout: TimeInterval = 20,
                environment: Environment = .dev) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.timeout = timeout
        self.environment = environment
    }
}
