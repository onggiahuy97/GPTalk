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
        
        #if os(macOS)
        .defaultSize(.init(width: 700, height: 800))
        .commands {
            CommandMenu("Text Size") {
                Button("Increse") {
                    appVM.fontSize += 1
                }
                .keyboardShortcut("+", modifiers: .command)
                
                Button("Decrease") {
                    appVM.fontSize -= 1
                }
                .keyboardShortcut("-", modifiers: .command)
            }
        }
        #endif
        
    
    }
}
