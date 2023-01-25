//
//  APIKeysView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/10/23.
//

import SwiftUI

struct APIKeysView: View {
  @EnvironmentObject var chatVM: ChatViewModel
  
  @Environment(\.dismiss) var dismiss
  
  @State private var token = ""
  @State private var errorMess = ""
  @State private var showAlert = false
  @State private var showErrorMess = false
  @State private var showTesting = false
  
  var body: some View {
    NavigationStack {
      List {
        Section {
          
        } footer: {
          VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading, spacing: 15) {
              Text("1. Visit the [**OpenAI**](https://beta.openai.com/account/api-keys) to get your API key")
              Text("2. Log in or Sign up for an account")
              Text("3. Generate a API key")
              Text("4. Copy and add the key to here")
            }
          }
        }
        
        Section("Your current API key") {
          Text("\(String(chatVM.token.prefix(2)))...\(String(chatVM.token.suffix(5)))")
            .lineLimit(1)
            .foregroundColor(.secondary)
        }
        
        Section {
          TextField("Your API key", text: $token)
        }
        
        Section {
        } footer: {
          Button {
            showTesting = true
            chatVM.text = "Tell me a joke"
            chatVM.modelType = .gpt3(.davinci)
            chatVM.model = .completions
            chatVM.fetchChat { res in
              if res == ChatGPTService.generalError {
                self.errorMess = "Failed. Retry with different API key"
              } else {
                self.errorMess = "Your API key words successfully"
              }
              showErrorMess = true
              showTesting = false
            }
            chatVM.text = ""
          } label: {
            Text(showTesting ? "Testing..." : "Test your current API key")
              .frame(maxWidth: .infinity, alignment: .center)
              .padding(10)
              .background(Color.blue)
              .foregroundColor(.white)
              .cornerRadius(10)
          }
          .alert(self.errorMess, isPresented: $showErrorMess) {
            Button(role: .cancel) {
              self.errorMess = ""
            } label: { Text("OK") }
          }
        }
      }
      .navigationTitle("API Key")
      .toolbar {
        ToolbarItem {
          Button(token.isEmpty ? "Done" : "Save") {
            if token.isEmpty { self.dismiss() }
            guard !token.isEmpty else { return }
            chatVM.token = token
            chatVM.modelType = .gpt3(.davinci)
            chatVM.maxTokens = Int(chatVM.modelType.maxTokens)!
            showAlert = true
            token = ""
          }
          .alert("Successfully added a new API key", isPresented: $showAlert) {
            Button(role: .cancel) { } label: { Text("OK") }
          }
        }
      }
    }
  }
}
