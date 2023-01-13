//
//  MaxTokenSettingView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/10/23.
//

import SwiftUI

struct MaxTokenSettingView: View {
    @EnvironmentObject var chatVM: ChatViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var appVM: AppViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var tokens = ""
    @State private var showSubscription = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(ChatGPTModelType.GPT3.allCases) { model in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(model.name)
                                .bold()
                            Text("· Model's Max Tokens: \(ChatGPTModelType.gpt3(model).maxTokens)")
                                .foregroundColor(.secondary)
                            Divider()
                        }
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(chatVM.modelType.modelString == model.rawValue ? 1 : 0)
                    }
                    .onTapGesture {
                        if userVM.subscriptionActive, let maxToken = Int(chatVM.modelType.maxTokens) {
                            chatVM.modelType = ChatGPTModelType.gpt3(model)
                            tokens = String(maxToken)
                        } else {
                            showSubscription = true
                        }
                    }
                }
                
                HStack(alignment: .center) {
                    Image(systemName: "exclamationmark.triangle")
                        .imageScale(.large)
                        .bold()
                    VStack(alignment: .leading) {
                        Text("· Free version can set up to **\(ChatViewModel.limitToken)** tokens")
                        Text("· Subscribers can set up to model's max token")
                    }
                }
                .padding(.top, 15)
                .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Your current tokens setting is ")
                        .foregroundColor(.secondary)
                        .bold()
                    + Text("\(chatVM.maxTokens)")
                        .bold()
                    TextField("Enter number of tokens to use", text: $tokens)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
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
                            if userVM.subscriptionActive, let maxToken = Int(chatVM.modelType.maxTokens) {
                                tokens = String(value > maxToken ? maxToken : value)
                            } else {
                                tokens = String(value > ChatViewModel.limitToken ? ChatViewModel.limitToken : value)
                                if value > ChatViewModel.limitToken {
                                    showSubscription = true
                                }
                            }
                        }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke())
                .padding(.vertical)
                .alert(isPresented: $showSubscription) {
                    Alert.subscriptionAlert {
                        appVM.showSubscription = true
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Set Max Tokens")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    guard let value = Int(tokens) else { return }
                    chatVM.maxTokens = value
                    self.dismiss()
                }
                .bold()
            }
        }
    }
}
