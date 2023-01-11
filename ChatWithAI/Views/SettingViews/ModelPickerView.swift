//
//  ModelPickerView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/10/23.
//

import SwiftUI

struct ModelPickerView: View {
    @EnvironmentObject var chatVM: ChatViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(ChatGPTModelType.GPT3.allCases) { model in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(model.name)
                                    .bold()
                                Text(ChatGPTModelType.gpt3(model).goodAt)
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
                }
                .padding()
            }
            .navigationTitle("Pick Model")
        }
    }
}

