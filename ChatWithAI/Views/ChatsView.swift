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
    @EnvironmentObject var userVM: UserViewModel
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\ChatMessage.date, order: .forward)])
    private var chats: FetchedResults<ChatMessage>
    
    @State private var showInformation = false
    @State private var isLoadingAnswer = false
    @State private var testSheet = false
    @State private var showSubscription = false
    @State private var showExamples = false
    
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
                        
                        if chats.isEmpty {
                            presentEmptyChatView
                        }
                        
                        ForEach(chats) { chat in
                            ChatMessageView(chat: chat, showSubscription: $showSubscription)
                                .fullScreenCover(item: $appVM.urlItem, onDismiss: {
                                    appVM.urlItem = nil
                                }) { item in
                                    WebView(url: item.url)
                                }
                                .alert(isPresented: $showSubscription) {
                                    Alert.subscriptionAlert {
                                        appVM.showSubscription = true
                                    }
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
                                    Label(model.name, systemImage: model.imageName)
                                        .tag(model)
                                }
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                .imageScale(.large)
                        }
                        .onChange(of: chatVM.model) { newValue in
                            if newValue != .completions {
                                chatVM.modelType = .gpt3(.davinci)
                                chatVM.maxTokens =
                                userVM.subscriptionActive ? Int(ChatGPTModelType.gpt3(.davinci).maxTokens)! : ChatViewModel.limitToken
                            }
                        }
                        
                        HStack(alignment: .top) {
                            TextField(textPrompt, text: $chatVM.text, axis: .vertical)
                                .lineLimit(5)
                                .focused($isTextFieldFocus)
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
                            
                            if !chatVM.text.isEmpty {
                                Button {
                                    chatVM.text = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                        .imageScale(.large)
                                }
                            }
                        }
                        .padding(.leading, 10)
                        .padding(.vertical, 5)
                        .padding(.trailing, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke()
                                .foregroundColor(.secondary)
                        )
                        
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
            .navigationTitle("AZUI")
            .toolbar {
                ToolbarItem {
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
        default:
            chatVM.fetchEdits { result in
                chat.answer = result
                chat.model = chatVM.model.rawValue
                DispatchQueue.main.async {
                    self.isLoadingAnswer = false
                    try? viewContext.save()
                }
            }
        }
    }
}
