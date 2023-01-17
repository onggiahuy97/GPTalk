//
//  ChatMessageView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/4/23.
//

import SwiftUI

struct ChatMessageView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @EnvironmentObject var appVM: AppViewModel
    
    @ObservedObject var chat: ChatMessage
    
    var menuView: some View {
        Menu {
            if let url = chat.question?.makeGoogleURL() {
                Button {
                    appVM.urlItem = URLItem(url: url)
                } label: {
                    Label("Google", systemImage: "text.magnifyingglass")
                }
            }
            
            Button(role: .destructive) {
                DispatchQueue.main.async {
                    withAnimation {
                        viewContext.delete(chat)
                        try? viewContext.save()
                    }
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
            
        } label: {
            HStack {
                Text((chat.date ?? Date()).toString())
                    .font(.footnote)
                Image(systemName: "ellipsis")
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                makeCircleImage(systemName: "person.fill.questionmark")
                Spacer()
                menuView
            }
            
            Text(chat.question ?? "")
            
            Divider()
                .padding(.bottom, 5)
            
            HStack(alignment: .top, spacing: 10) {
                HStack(alignment: .center, spacing: 10) {
                    makeCircleImage(systemName: "pc")
                    
                    if chat.answer == nil {
                        ProgressView()
                    }
                }
                
                Spacer()
                
            }
            
            Text(chat.answer ?? "")
                .textSelection(.enabled)
            
        }
        .padding()
        .foregroundColor(.accentColor)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke()
        )
    }
}
