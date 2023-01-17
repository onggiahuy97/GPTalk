//
//  APIKeysView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/10/23.
//

import SwiftUI

struct APIKeysView: View {
    @EnvironmentObject var chatVM: ChatViewModel
    
    @State private var token = ""
    @State private var errorMess = ""
    @State private var showAlert = false
    @State private var showErrorMess = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("1. Visit the [**OpenAI**](https://beta.openai.com/account/api-keys) to get your API key")
                    Text("2. Log in or Sign up for an account")
                    Text("3. Generate a API key")
                    Text("4. Copy and add the key to here")
                }
                .foregroundColor(.secondary)
                
                VStack {
                    Text("Your current API key:")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.secondary)
                    Text("\(chatVM.token)")
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke()
                        .foregroundColor(.secondary)
                }
                
                TextField("Your API key", text: $token)
                    .textFieldStyle(.roundedBorder)
                
                Button {
                    chatVM.fetchCurrentSetting()
                    chatVM.text = "Tell me a joke"
                    chatVM.fetchChat { res in
                        if res == ChatGPTService.generalError {
                            self.errorMess = "Failed. Retry with different API key"
                        } else {
                            self.errorMess = "Your API key words successfully"
                        }
                        showErrorMess = true
                    }
                    chatVM.text = ""
                } label: {
                    Text("Test your current API key")
                        .padding(10)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(12)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .alert(self.errorMess, isPresented: $showErrorMess) {
                    Button(role: .cancel) {
                        self.errorMess = ""
                    } label: { Text("OK") }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .navigationTitle("API Key")
        .toolbar {
            ToolbarItem {
                Button("Save") {
                    guard !token.isEmpty else { return }
                    chatVM.token = token
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
