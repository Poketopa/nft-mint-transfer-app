//
//  AuthViewModel.swift
//  NFTMintTransfer
//
//  Created by 이민석 on 9/8/25.
//

import Foundation
import NetworkingKitJWT

/// 로그인 상태와 동작을 관리하는 뷰모델
@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""             // 입력한 이메일
    @Published var password = ""          // 입력한 비밀번호
    @Published var isLoading = false      // 로그인 진행 중 여부
    @Published var error: String?         // 에러 메시지
    @Published var loggedInUser: UserDTO? // 로그인 성공 시 사용자 정보 저장

    /// 이메일/비밀번호 간단 유효성 검사
    var isFormValid: Bool {
        email.contains("@") && password.count >= 6
    }

    /// 로그인 요청
    func login() async {
        guard isFormValid else {
            error = "이메일 형식과 6자 이상 비밀번호를 확인하세요"
            return
        }
        error = nil
        isLoading = true
        do {
            // 서버에 로그인 요청
            let user = try await NetworkContainer.auth.login(email: email, password: password)
            loggedInUser = user

            // (선택) JWT 만료 여부 확인
            if let jwt = NetworkContainer.auth.currentJWT() {
                print("JWT exp:", jwt.exp ?? -1, "만료됨:", jwt.isExpired)
            }
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
