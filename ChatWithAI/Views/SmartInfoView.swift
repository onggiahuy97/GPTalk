//
//  SmartInfoView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/4/23.
//

import SwiftUI

struct SmartInfoView: View {
    var smartInfos: [SmartInfo]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(smartInfos) { info in
                        HStack {
                            Label(info.nameType, systemImage: info.systemName)
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                        }
                        ForEach(info.names, id: \.self) { name in
                            Group {
                                if let url = name.makeGoogleURL() {
                                    Link("· \(name)", destination: url)
                                } else {
                                    Text("· \(name)")
                                }
                            }
                            .font(.title3)
                            .padding(.leading)
                            
                        }
                        Divider()
                            .padding(.vertical)
                    }
                }
                .padding()
            }
            .navigationTitle("Look What I Found")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                }
            }
        }
    }
    
    private func fetchQuickReview() {
        let search = smartInfos.first?.names.first ?? ""

        let openAI = ChatGPTService(token: "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")
        openAI.sendCompletion(with: search, model: .gpt3(.davinci), maxTokens: 30) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let openAIResult):
                let text = openAIResult.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                print(text)
            }
        }
    }
}
