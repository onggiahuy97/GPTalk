//
//  ModelPickerView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/10/23.
//

import SwiftUI

struct ModelPickerView: View {
    @EnvironmentObject var chatVM: ChatViewModel
    @EnvironmentObject var appVM: AppViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var showSubscription = false
    
    var body: some View {
        List {
            Section {
                ForEach(ChatGPTModelType.GPT3.allCases) { model in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(model.name)
                                .bold()
                            Text(ChatGPTModelType.gpt3(model).goodAt)
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
        }
        .navigationTitle("Pick Model")
        .toolbar {
            ToolbarItem {
                Button("Save", action: dismiss.callAsFunction)
            }
        }
    }
}
