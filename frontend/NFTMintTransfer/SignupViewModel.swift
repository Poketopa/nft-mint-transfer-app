//
//  SignupViewModel.swift
//  NFTMintTransfer
//
//  Created by 이민석 on 9/8/25.
//

import Foundation
import UIKit
import NetworkingKitJWT

@MainActor
final class SignupViewModel: ObservableObject {
    @Published var email = ""                // 입력한 이메일
    @Published var nickname = ""             // 입력한 닉네임
    @Published var password = ""             // 입력한 비밀번호
    @Published var confirmPassword = ""      // 입력한 비밀번호 확인
    @Published var isLoading = false         // 회원가입 진행 중 여부
    @Published var error: String?            // 에러 메시지
    @Published var isSignupSuccess = false   // 회원가입 성공 여부
    @Published var selectedImage: UIImage?   // 선택된 이미지
    
    /// 폼 유효성 검사
    var isFormValid: Bool {
        email.contains("@") &&
        !nickname.isEmpty &&
        nickname.count >= 2 &&
        nickname.count <= 10 &&
        password.count >= 8 &&
        password == confirmPassword
    }
    
    /// 회원가입 요청
    func signup() async {
        guard isFormValid else {
            if !email.contains("@") {
                error = "올바른 이메일 형식을 입력하세요"
            } else if nickname.isEmpty {
                error = "닉네임을 입력하세요"
            } else if nickname.count < 2 || nickname.count > 10 {
                error = "닉네임은 2자 이상 10자 이하여야 합니다"
            } else if password.count < 8 {
                error = "비밀번호는 8자 이상이어야 합니다"
            } else if password != confirmPassword {
                error = "비밀번호가 일치하지 않습니다"
            }
            return
        }
        
        error = nil
        isLoading = true
        
        do {
            // 선택된 이미지를 Data로 변환
            var imageData: Data? = nil
            if let selectedImage = selectedImage {
                imageData = selectedImage.jpegData(compressionQuality: 0.8)
            }
            
            // 서버에 회원가입 요청
            let user = try await NetworkContainer.auth.signup(
                email: email,
                nickname: nickname,
                password: password,
                profileImage: imageData
            )
            
            print("회원가입 성공: \(user)")
            isSignupSuccess = true
            
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
}
