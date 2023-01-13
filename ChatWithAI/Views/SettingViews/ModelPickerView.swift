//
//  ModelPickerView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/10/23.
//

import SwiftUI

struct ModelPickerView: View {
    @EnvironmentObject var chatVM: ChatViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var appVM: AppViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var showSubscription = false
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
                            if userVM.subscriptionActive {
                                chatVM.modelType = ChatGPTModelType.gpt3(model)
                            } else {
                                showSubscription = true
                            }
                        }
                        .alert(isPresented: $showSubscription) {
                            Alert.subscriptionAlert {
                                appVM.showSubscription = true
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Pick Model")
        }
    }
}

