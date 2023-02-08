//
//  ChatWithAIApp.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/2/23.
//

import SwiftUI

@main
struct ChatWithAIApp: App {
  @StateObject var chatVM: ChatViewModel
  @StateObject var appVM: AppViewModel
  @StateObject var dataVM: DataViewModel
  
  init() {
    _chatVM = StateObject(wrappedValue: ChatViewModel())
    _appVM = StateObject(wrappedValue: AppViewModel())
    let context = DataController.shared.container.viewContext
    _dataVM = StateObject(wrappedValue: DataViewModel(context: context))
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, DataController.shared.container.viewContext)
        .environmentObject(chatVM)
        .environmentObject(appVM)
        .environmentObject(dataVM)
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
