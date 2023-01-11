//
//  ChatWithAIApp.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/2/23.
//

import SwiftUI
import RevenueCat

@main
struct ChatWithAIApp: App {
    @StateObject var chatVM = ChatViewModel()
    @StateObject var appVM = AppViewModel()
    @StateObject var userVM = UserViewModel()
    
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(with: Configuration.Builder(withAPIKey: Constants.apiKey)
            .with(usesStoreKit2IfAvailable: true)
            .build()
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, DataController.shared.container.viewContext)
                .environmentObject(chatVM)
                .environmentObject(appVM)
                .environmentObject(userVM)
                .task {
                    do {
                        userVM.offerings = try await Purchases.shared.offerings()
                    } catch {
                        print("Error fetching offerings \(error)")
                    }
                }
        }
    }
}
