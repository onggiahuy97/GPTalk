//
//  MaxTokenSettingView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/10/23.
//

import SwiftUI

struct MaxTokenSettingView: View {
    @EnvironmentObject var chatVM: ChatViewModel
    @Environment(\.dismiss) var dismiss
    @State private var tokens = ""
    
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
                        chatVM.modelType = ChatGPTModelType.gpt3(model)
                    }
                }
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
                            tokens = String(value > ChatViewModel.limitToken ? ChatViewModel.limitToken : value)
                        }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke())
                .padding(.vertical)
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
