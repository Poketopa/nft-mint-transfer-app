//
//  NetworkContainer.swift
//  NFTMintTransfer
//
//  Created by 이민석 on 9/8/25.

import Foundation
import NetworkingKitJWT

/// 앱 전역에서 재사용하는 네트워킹 의존성 모음
enum NetworkContainer {

    /// 공통 설정 (✅ 실제 서버 주소로 교체)
    static let config = NetworkConfig(
        baseURL: URL(string: "https://YOUR-BACKEND.EXAMPLE")!
    )

    /// HTTP 클라이언트: 토큰 자동첨부, 로깅, JSON 디코딩
    static let client = APIClient(
        config: config,
        session: URLSession(configuration: .ephemeral),
        requestAdapters: [AuthTokenAdapter { KeychainTokenStore().loadAccessToken() }],
        responseMiddlewares: [LoggerMiddleware()],
        decoder: .presetRFC3339SnakeCase
    )

    /// 인증 서비스: 로그인 성공 시 JWT를 Keychain에 저장
    static let auth = AuthService(
        client: client,
        tokenStore: KeychainTokenStore()
    )
}
