//
//  SettingsView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/4/23.
//

import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var appVM: AppViewModel
  @EnvironmentObject var dataVM: DataViewModel
  
  @Environment(\.managedObjectContext) var viewContext
  
  @State private var showAPIKeysView = false
  @State private var showModelPickerView = false
  @State private var showMaxTokenSettingView = false
  
  var apiKeysView: some View {
    Section {
      Button {
        showAPIKeysView = true
      } label: {
        Label("API Keys", systemImage: "key")
      }
      .sheet(isPresented: $showAPIKeysView) {
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
      Button {
        showModelPickerView = true
      } label: {
        Label("Model", systemImage: "cube.transparent")
      }
      .sheet(isPresented: $showModelPickerView) {
        ModelPickerView()
      }
    } header: {
      Text("Chat Model")
    } footer: {
      Text("GPT-3 models can understand and generate natural language. We offer four main models with different levels of power. Davinci is the most capable model, and Ada is the fastest.")
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
      Button("Current Setting") {
        showInformation.toggle()
      }
      .sheet(isPresented: $showInformation) {
        InformationView()
          .onDisappear(perform: appVM.checkIfHasSeenBefore)
      }
      NavigationLink("Model GPT-3") {
        Form {
          Section {
            ForEach(ChatGPTModelType.GPT3.allCases) { model in
              VStack(alignment: .leading) {
                
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
              }
            }
          }
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
      Button("Clear Chats But Keep Favorite Chats") {
        dataVM.deleteAllNotFavoriteChats()
      }
      Button("Clear All History Chats") {
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
      }
    }
    .foregroundColor(.blue)
  }
  
  var body: some View {
    NavigationStack {
      List {
        aboutMeView
        apiKeysView
        modelTypesView
        chatgpt3View
        generalSettingView
      }
      .navigationTitle("Settings")
    }
  }
}

