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
                        TextField("Enter Chat", text: $chatVM.text)
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
                            .onAppear {
                                scrollProxy.scrollTo("last")
                                showInformation = appVM.isFirstLauch
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: deleteAllChats) {
                        Image(systemName: "trash")
                            .foregroundColor(.accentColor)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showInformation.toggle()
                    } label: {
                        Image(systemName: "exclamationmark.square")
                    }
                    .sheet(isPresented: $showInformation) {
                        InformationView()
                            .onDisappear(perform: appVM.checkIfHasSeenBefore)
                    }
                }
            }
        }
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
        
        chatVM.fetchChat { result in
            chat.answer = result
            DispatchQueue.main.async {
                self.isLoadingAnswer = false
                try? viewContext.save()
            }
        }
    }
    
    private func deleteAllChats() {
        chats.forEach {
            viewContext.delete($0)
        }
        try? viewContext.save()
    }
    
}
