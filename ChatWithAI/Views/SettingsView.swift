//
//  SettingsView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/4/23.
//

import SwiftUI
import LocalAuthentication

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

struct APIKeysView: View {
    @State private var isUnlocked = false
    
    var body: some View {
        Group {
            if isUnlocked {
                Text("Unclock")
            } else {
                Button("Click here to unlock") {
                    authenticate()
                }
                .bold()
                .padding()
                .foregroundColor(.blue)
            }
        }
        .onAppear(perform: authenticate)
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authentication Keys API Purposes"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { grant, error in
                if grant {
                    isUnlocked = true
                } else {
                    
                }
            }
        } else {
            
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var appVM: AppViewModel
    
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
            makeRow(title: "Model", systemName: "cube.transparent", color: .red) {
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
            Text(" Tokens can be words or just chunks of characters. For example, the word “hamburger” gets broken up into the tokens “ham”, “bur” and “ger”. Check out [**Tokenizer**](https://beta.openai.com/tokenizer) tool to learn more about how text translates to tokens.")
        }
    }
    
    var aboutMeView: some View {
        Section {
            
        } header: {
            
        } footer: {
            HStack {
                Spacer()
                Text("Made by **Huy Ong** with love ♥️")
                Spacer()
            }
            .multilineTextAlignment(.center)
        }
    }
    
    var chatgpt3View: some View {
        Section {
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
    
    var body: some View {
        NavigationStack {
            Form {
                apiKeysView
                maxTokensView
                modelTypesView
                chatgpt3View
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

