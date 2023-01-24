//
//  ChatsView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/4/23.
//

import SwiftUI

struct ChatsView: View {
  
  @EnvironmentObject var chatVM: ChatViewModel
  @EnvironmentObject var appVM: AppViewModel
  
  @Environment(\.managedObjectContext) var viewContext
  @Environment(\.colorScheme) var colorScheme
  
  @FetchRequest(sortDescriptors: [SortDescriptor(\ChatMessage.date, order: .forward)])
  private var chats: FetchedResults<ChatMessage>
  
  @State private var showInformation = false
  @State private var isLoadingAnswer = false
  @State private var showExamples = false
  @State private var showAlert = false
  @State private var showAddAPIKey = false
  
  @FocusState private var isTextFieldFocus: Bool
  
  var presentEmptyChatView: some View {
    VStack {
      Spacer()
        .frame(height: 20)
      Label("What's on your mind?", systemImage: "person.fill.questionmark")
        .bold()
        .frame(maxWidth: .infinity, alignment: .center)
      Spacer()
    }
  }
  
  var textPrompt: String {
    switch chatVM.model {
    case .completions: return "Enter chat"
    case .fixGrammar: return "Check grammar"
    case .pharaphrase: return "Paraphrasing text"
    }
  }
  
  var body: some View {
    NavigationStack {
      ScrollViewReader { scrollProxy in
        VStack(alignment: .leading) {
          ScrollView {
            Spacer()
              .frame(height: 10)
            
            if chats.isEmpty {
              presentEmptyChatView
            }
            
            ForEach(chats) { chat in
              ChatMessageView(chat: chat)
              
                #if os(iOS)
                .fullScreenCover(item: $appVM.urlItem, onDismiss: {
                  appVM.urlItem = nil
                }) { item in
                  WebView(url: item.url)
                }
                #endif
            }
            .padding(.horizontal)
            
            Spacer()
              .frame(height: 5)
              .id("last")
          }
          .scrollDismissesKeyboard(.immediately)
          
          HStack {
            TextField(textPrompt, text: $chatVM.text, axis: .vertical)
              .lineLimit(5)
              .focused($isTextFieldFocus)
              .textFieldStyle(.roundedBorder)
              .onChange(of: isTextFieldFocus) { _ in scrollToLast(scrollProxy) }
              .onChange(of: chats.count) { _ in scrollToLast(scrollProxy) }
              .onChange(of: chats.last?.answer) { _ in scrollToLast(scrollProxy) }
              .onChange(of: chatVM.text) { newValue in
                if chatVM.model != .completions {
                  if newValue.count > chatVM.maxTokens {
                    chatVM.text = String(newValue.prefix(chatVM.maxTokens))
                  }
                }
              }
              .onAppear {
                scrollProxy.scrollTo("last")
                showInformation = appVM.isFirstLauch
                deleteUnansweredQuestions()
              }
            
              #if os(macOS)
              .onSubmit {
                onSubmitChat()
              }
              #endif
            
            
            if !chatVM.text.isEmpty {
              Button {
                chatVM.text = ""
              } label: {
                Image(systemName: "xmark.circle.fill")
                  .foregroundColor(.secondary)
                  .imageScale(.large)
              }
            }
            
            Button(action: onSubmitChat) {
              Image(systemName: "paperplane.fill")
                .foregroundColor(.accentColor)
                .rotationEffect(.degrees(45))
                .imageScale(.large)
            }
            .disabled(isLoadingAnswer)
            
          }
          .padding([.horizontal, .bottom])
        }
      }
      
#if os(macOS)
      .background(colorScheme == .light ? Color.white : Color.black)
#endif
      
      .navigationTitle("GPTalk")
      
#if os(iOS)
      .navigationBarTitleDisplayMode(.inline)
#endif
      
      .toolbar {
        
#if os(iOS)
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            showExamples = true
          } label: {
            Image(systemName: "questionmark.bubble")
              .imageScale(.large)
          }
          .sheet(isPresented: $showExamples) {
            ExamplesView()
          }
        }
        
        if !chatVM.goodAPI {
          ToolbarItem {
            Button {
              showAlert = true
            } label: {
              Image(systemName: "exclamationmark.triangle.fill")
            }
            .foregroundColor(.red)
            .alert("API Key", isPresented: $showAlert) {
              Button("Ok") {
                showAddAPIKey = true
              }
            } message: {
              Text("Please make sure you have provided a valid API Key")
            }
            .sheet(isPresented: $showAddAPIKey) {
              APIKeysView()
            }
          }
        }
        
#endif
        
        ToolbarItem {
          Menu {
            Picker("Model", selection: $chatVM.model) {
              ForEach(ChatViewModel.ModelType.allCases) { model in
                Button {
                  chatVM.model = model
                } label: {
                  Label(model.name, systemImage: model.imageName)
                  
                }
                .tag(model)
              }
            }
            .pickerStyle(.inline)
          } label: {
            Label("", systemImage: "line.3.horizontal.decrease.circle.fill")
              .imageScale(.large)
          }
          .onChange(of: chatVM.model) { newValue in
            if newValue != .completions {
              chatVM.modelType = .gpt3(.davinci)
            }
          }
        }
        
        
        #if os(macOS)
        ToolbarItem {
          Button {
            chats.forEach { viewContext.delete($0) }
            try? viewContext.save()
          } label: {
            Image(systemName: "trash")
          }
        }
        #endif
      }
    }
  }
  
  private func scrollToLast(_ scrollProxy: ScrollViewProxy) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      withAnimation {
        scrollProxy.scrollTo("last")
      }
    }
  }
  
  private func deleteUnansweredQuestions() {
    let unanswerQuestions = chats.filter { chat in
      (chat.answer ?? "").isEmpty || chat.answer == ChatGPTService.generalError
    }
    unanswerQuestions.forEach {
      viewContext.delete($0)
    }
    try? viewContext.save()
  }
  
  private func onSubmitChat() {
    guard !chatVM.text.isEmpty else { return }
    
    #if os(iOS)
    let impact = UIImpactFeedbackGenerator(style: .light)
    impact.impactOccurred()
    #endif
    
    isLoadingAnswer = true
    isTextFieldFocus = true
    
    let chat = ChatMessage(context: viewContext)
    chat.question = chatVM.text
    chat.date = Date()
    
    try? viewContext.save()
    
    switch chatVM.model {
    case .completions:
      chatVM.fetchChat { result in
        chat.answer = result
      }
    default:
      chatVM.fetchEdits { result in
        chat.answer = result
      }
    }
    
    DispatchQueue.main.async {
      isLoadingAnswer = false
      chatVM.text = ""
      try? viewContext.save()
    }
  }
}
