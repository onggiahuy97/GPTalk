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
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\ChatMessage.date, order: .forward)])
    private var chats: FetchedResults<ChatMessage>
    
    @State private var showInformation = false
    @State private var isLoadingAnswer = false
    @State private var testSheet = false
    
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
        case .edits: return "Enter your text"
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollProxy in
                VStack(alignment: .leading) {
                    ScrollView {
                        
                        if chats.isEmpty {
                            presentEmptyChatView
                        }
                        
                        ForEach(chats) { chat in
                            ChatMessageView(chat: chat)
                                .fullScreenCover(item: $appVM.urlItem, onDismiss: {
                                    appVM.urlItem = nil
                                }) { item in
                                    WebView(url: item.url)
                                }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                            .frame(height: 5)
                            .id("last")
                    }
                    .scrollDismissesKeyboard(.immediately)
                    
                    HStack {
                        Menu {
                            Picker("Model", selection: $chatVM.model) {
                                ForEach(ChatViewModel.ModelType.allCases) { model in
                                    Text(model.name)
                                        .tag(model)
                                }
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                .imageScale(.large)
                        }
                        
                        TextField(textPrompt, text: $chatVM.text)
                            .focused($isTextFieldFocus)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: isTextFieldFocus) { _ in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation {
                                        scrollProxy.scrollTo("last")
                                    }
                                }
                            }
                            .onChange(of: chats.count) { _ in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation {
                                        scrollProxy.scrollTo("last")
                                    }
                                }
                            }
                            .onChange(of: chats.last?.answer) { _ in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation {
                                        scrollProxy.scrollTo("last")
                                    }
                                }
                            }
                            .onChange(of: chatVM.text) { newValue in
                                if chatVM.model == .edits {
                                    if newValue.count > ChatViewModel.limitCharacters {
                                        chatVM.text = String(newValue.prefix(ChatViewModel.limitCharacters))
                                    }
                                }
                            }
                            .onAppear {
                                scrollProxy.scrollTo("last")
                                showInformation = appVM.isFirstLauch
                                deleteUnansweredQuestions()
                                
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
            .navigationTitle("GPTalk")
        }
    }
    
    private func deleteUnansweredQuestions() {
        let unanswerQuestions = chats.filter { chat in
            (chat.answer ?? "").isEmpty
        }
        unanswerQuestions.forEach {
            viewContext.delete($0)
        }
        try? viewContext.save()
    }
    
    private func onSubmitChat() {
        guard !chatVM.text.isEmpty else { return }
        
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
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
                chat.model = "chat"
                DispatchQueue.main.async {
                    self.isLoadingAnswer = false
                    try? viewContext.save()
                }
            }
        case .edits:
            chatVM.fixGrammar { result in
                chat.answer = result
                chat.model = "grammar"
                DispatchQueue.main.async {
                    self.isLoadingAnswer = false
                    try? viewContext.save()
                }
            }
        }
    }
}
