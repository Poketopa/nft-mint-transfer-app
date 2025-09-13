//
//  LoginView.swift
//  NFTMintTransfer
//
//  Created by 이민석 on 9/8/25.
//

import SwiftUI

/// 로그인 화면
struct LoginView: View {
    @StateObject private var vm = AuthViewModel()

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("이메일").font(.caption).foregroundStyle(.secondary)
                TextField("you@example.com", text: $vm.email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)

                Text("비밀번호").font(.caption).foregroundStyle(.secondary)
                SecureField("6자 이상", text: $vm.password)
                    .textFieldStyle(.roundedBorder)
            }

            Button {
                Task { await vm.login() }
            } label: {
                if vm.isLoading {
                    ProgressView()
                } else {
                    Text("로그인")
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.isLoading)

            // 에러 메시지
            if let err = vm.error {
                Text(err)
                    .foregroundStyle(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }

            // 성공 시 사용자 정보 표시
            if let user = vm.loggedInUser {
                VStack {
                    Text("로그인 성공!")
                        .foregroundStyle(.green)
                        .fontWeight(.bold)
                    Text("이메일: \(user.email)")
                        .foregroundStyle(.secondary)
                    if !user.nickname.isEmpty {
                        Text("닉네임: \(user.nickname)")
                            .foregroundStyle(.secondary)
                    }
                }
            }

            // 회원가입 버튼
            NavigationLink {
                SignupView()
            } label: {
                Text("회원가입")
                    .foregroundStyle(.blue)
            }
        }
        .padding(24)
        .navigationTitle("로그인")
    }
}
#Preview { NavigationStack { LoginView() } }
