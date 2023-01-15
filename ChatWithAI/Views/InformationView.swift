//
//  InformationView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/4/23.
//

import SwiftUI

struct InformationView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var chatVM: ChatViewModel
    
    @State private var showPayWall = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    makeRow(header: ChatGPTModelType.GPT3(rawValue: chatVM.modelType.modelString)?.name ?? "", content: chatVM.modelType.goodAt, systemName: "cube.transparent")
                    makeRow(header: "Max Tokens", content: "\(ChatViewModel.limitToken) · More tokens give more words in answer", systemName: "centsign.circle")
                    makeRow(header: "Training Data", content: chatVM.modelType.trainingData, systemName: "calendar.circle")
                    makeRow(header: "Description", content: chatVM.modelType.description, systemName: "doc.circle")
                    Divider()
                    makeRow(header: "Grammar", content: "The model can fix grammar up to \(ChatViewModel.limitCharacters) characters", systemName: "wrench.and.screwdriver")
                    
                    Button {
                        showPayWall.toggle()
                    } label: {
                        VStack {
                            Text("Get Subscription")
                                .bold()
                            Text("So, you can fully customize")
                                .font(.callout)
                                .minimumScaleFactor(0.5)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .sheet(isPresented: $showPayWall) {
                        PayWall()
                    }
//                    .disabled(true)
                    #warning("Beta testing")

                    Spacer()
                }
                .padding(30)
                .navigationTitle("Free Version")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            self.dismiss()
                        } label : {
                            Image(systemName: "xmark.circle")
                        }
                    }
                }
            }
        }
    }
    
    func makeRow(header: String, content: String, systemName: String) -> some View {
        HStack(alignment: .top, spacing: 20) {
            Image(systemName: systemName)
                .font(.system(size: 36))
            VStack(alignment: .leading) {
                Text(header)
                    .bold()
                Text(content)
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.7)
            }
            Spacer()
        }
    }
}
