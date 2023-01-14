//
//  SettingsView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/4/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var userVM: UserViewModel
    
    @Environment(\.managedObjectContext) var viewContext
    @State private var showSubscription = false
    var payWallView: some View {
        Section {
            makeRow(title: "Subscriptions", systemName: "lock.fill", color: .red) {
                PayWall()
            }
        } header: {
            Text("Subscription")
        } footer: {
            Text("You can choose any subscriptions you'd like to unlock full potential of the app :)")
        }
    }
    
    var apiKeysView: some View {
        Section {
            makeRow(title: "API Keys", systemName: "key", color: .blue) {
                APIKeysView()
            }
        } header: {
            Text("API Keys")
        } footer: {
            Text("The OpenAI API uses API keys for authentication. Visit your [**API Keys**](https://beta.openai.com/account/api-keys) page to retrieve the API key you'll use in your requests.")
        }
    }
    
    var modelTypesView: some View {
        Section {
            makeRow(title: "Model", systemName: "cube.transparent", color: .green) {
                ModelPickerView()
            }
        } header: {
            Text("Chat Model")
        } footer: {
            Text("GPT-3 models can understand and generate natural language. We offer four main models with different levels of power. Davinci is the most capable model, and Ada is the fastest.")
        }
    }
    
    var maxTokensView: some View {
        Section {
            makeRow(title: "Max Tokens", systemName: "cedisign.circle", color: .yellow) {
                MaxTokenSettingView()
            }
        } header: {
            Text("Tokens")
        } footer: {
            Text("Tokens can be words or just chunks of characters. The less tokens, the faster response. Check out [**Tokenizer**](https://beta.openai.com/tokenizer) tool to learn more about how text translates to tokens.")
        }
    }
    
    var aboutMeView: some View {
        Section {
            
        } header: {
            
        } footer: {
            HStack {
                Spacer()
                Text("Made by [**Huy Ong**](https://twitter.com/OGHuy18) with love ♥️")
                Spacer()
            }
            .multilineTextAlignment(.center)
        }
    }
    
    @State private var showInformation = false
    
    var chatgpt3View: some View {
        Section {
            Button("Free Version Info") {
                showInformation.toggle()
            }
            .sheet(isPresented: $showInformation) {
                InformationView()
                    .onDisappear(perform: appVM.checkIfHasSeenBefore)
            }
            NavigationLink("Model GPT-3") {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(ChatGPTModelType.GPT3.allCases) { model in
                            HStack {
                                Text(model.name)
                                Spacer()
                            }
                            .bold()
                            .font(.title2)
                            VStack(alignment: .leading) {
                                Text("**Model**: \(model.rawValue)")
                                Text("**Description**: \(ChatGPTModelType.gpt3(model).description)")
                                Text("**Good at**: \(ChatGPTModelType.gpt3(model).goodAt)")
                                Text("**Training data**: \(ChatGPTModelType.gpt3(model).trainingData)")
                                Text("**Max tokens**: \(ChatGPTModelType.gpt3(model).maxTokens)")
                            }
                            .minimumScaleFactor(0.75)
                            .foregroundColor(.secondary)
                                
                            Divider()
                                .padding(.vertical)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Model GPT-3")
            }
        } header: {
            Text("Model Information")
        } footer: {
            Text("Our base GPT-3 models are called Davinci, Curie, Babbage and Ada. To learn more, visit our [**models documentation**](https://beta.openai.com/docs/models).")
        }
    }
    
    var generalSettingView: some View {
        Section {
            Button("Clear All History Chats") {
                if userVM.subscriptionActive {
                    let chatsRequest = ChatMessage.fetchRequest()
                    do {
                        let chats = try viewContext.fetch(chatsRequest)
                        chats.forEach {
                            viewContext.delete($0)
                        }
                        try viewContext.save()
                    } catch {
                        print("Error \(error.localizedDescription)")
                        return
                    }
                } else {
                    self.showSubscription = true
                }
            }
            .foregroundColor(.blue)
            .alert(isPresented: $showSubscription) {
                Alert.subscriptionAlert {
                    appVM.showSubscription = true
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                if userVM.subscriptionActive {
                    Section {} header: {} footer: {
                        HStack {
                            Spacer()
                            VStack(alignment: .center) {
                                Text("Pro subscription")
                                Text("Thank you for being a subscriber ♥️")
                            }
                            Spacer()
                        }
                        .multilineTextAlignment(.center)
                    }
                }
                #warning("Beta testing")
                payWallView
                    .disabled(true)
//                apiKeysView
                maxTokensView
                modelTypesView
                chatgpt3View
                generalSettingView
                aboutMeView
            }
            .navigationTitle("Settings")
            
        }
    }
    
    private func makeRow(title: String, systemName: String, color: Color, content: () -> some View) -> some View {
        NavigationLink(destination: content) {
            HStack(alignment: .center, spacing: 15) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 28, height: 28)
                    .foregroundColor(color)
                    .overlay(alignment: .center) {
                        Image(systemName: systemName)
                            .imageScale(.small)
                            .foregroundColor(.white)
                    }
                Text(title)
                Spacer()
            }
        }
    }
}

