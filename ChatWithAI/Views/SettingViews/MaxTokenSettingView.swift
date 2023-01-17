//
//  MaxTokenSettingView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/10/23.
//

import SwiftUI

struct MaxTokenSettingView: View {
    @EnvironmentObject var chatVM: ChatViewModel
    @EnvironmentObject var appVM: AppViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var tokens = ""
    @State private var showSubscription = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(ChatGPTModelType.GPT3.allCases) { model in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(model.name)
                                    .bold()
                                Text("· Model's Max Tokens: \(ChatGPTModelType.gpt3(model).maxTokens)")
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "checkmark")
                                .opacity(chatVM.modelType.modelString == model.rawValue ? 1 : 0)
                        }
                        .onTapGesture {
                            chatVM.modelType = ChatGPTModelType.gpt3(model)
                            if let maxTokens = Int(chatVM.modelType.maxTokens) {
                                chatVM.maxTokens = maxTokens
                            }
                        }
                    }
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Your current tokens setting is ")
                            .foregroundColor(.secondary)
                            .bold()
                        + Text("\(chatVM.maxTokens)")
                            .bold()
                        TextField("Enter number of tokens", text: $tokens)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: tokens) { newValue in
                                let allowed = CharacterSet.decimalDigits
                                let set = CharacterSet(charactersIn: newValue)
                                guard allowed.isSuperset(of: set) else {
                                    tokens.removeAll { c in
                                        !c.isNumber
                                    }
                                    return
                                }
                                guard let value = Int(newValue) else { return }
                                if let maxToken = Int(chatVM.modelType.maxTokens) {
                                    tokens = String(value > maxToken ? maxToken : value)
                                }
                            }
                    }
                    
                } header: {
                    HStack(alignment: .center) {
                        Image(systemName: "exclamationmark.triangle")
                            .imageScale(.large)
                            .bold()
                        VStack(alignment: .leading) {
                            Text("· You can set limit for your token")
                        }
                    }
                    .padding(.top, 15)
                    .foregroundColor(.secondary)
                    
                }
            }
            .navigationTitle("Set Max Tokens")
            #if os(iOS)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard let value = Int(tokens) else {
                            self.dismiss()
                            return
                        }
                        chatVM.maxTokens = value
                        self.dismiss()
                    }
                }
            }
            #endif
        }
    }
}
