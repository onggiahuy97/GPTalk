//
//  ChatWithAIApp.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/2/23.
//

import SwiftUI

@main
struct ChatWithAIApp: App {
    @StateObject var chatVM = ChatViewModel()
    @StateObject var appVM = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, DataController.shared.container.viewContext)
                .environmentObject(chatVM)
                .environmentObject(appVM)
        }
    }
}
