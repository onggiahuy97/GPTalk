//
//  ContentView.swift
//  MacGPTalk
//
//  Created by Huy Ong on 1/16/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var chatVM: ChatViewModel
    
    @State private var showAlert = false
    @State private var token = ""
    
    var body: some View {
        ChatsView()
            .toolbar {
                ToolbarItem {
                    Button("Your API Key") {
                        showAlert = true
                    }
                    .alert("API Key", isPresented: $showAlert) {
                        TextField("Key", text: $token)
                        
                        Button("Add") {
                            chatVM.token = token
                            chatVM.modelType = .gpt3(.davinci)
                            chatVM.model = .completions
                            chatVM.maxTokens = Int(chatVM.modelType.maxTokens)!
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Please add your private API key to use the app\nYour current API key:\n")
                        + Text("\(String(chatVM.token.prefix(5)))...\(String(chatVM.token.suffix(5)))")
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
