//
//  NFTMintTransferApp.swift
//  NFTMintTransfer
//
//  Created by 이민석 on 9/6/25.
//

import SwiftUI

@main
struct NFTMintTransferApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LoginView()   // 앱 시작 시 로그인 화면 표시
            }
        }
    }
}
