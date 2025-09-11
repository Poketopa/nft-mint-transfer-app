//
//  NFTMintTransferApp.swift
//  NFTMintTransfer
//
//  Created by 이민석 on 9/6/25.
//

import SwiftUI

@main
struct NFTMintTransferApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
