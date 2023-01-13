//
//  ChatMessageView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/4/23.
//

import SwiftUI

struct ChatMessageView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var userVM: UserViewModel
    
    @Environment(\.managedObjectContext) var viewContext
    
    @ObservedObject var chat: ChatMessage
    
    @State private var showMoreInformation = false
    
    @Binding var showSubscription: Bool
    
    var smartInfos: [SmartInfo] {
        return (chat.answer?.getRangeOfPersonName() ?? [])
            .sorted(by: { $0.tag.rawValue < $1.tag.rawValue })
    }
    
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
                    if userVM.subscriptionActive {
                        withAnimation {
                            viewContext.delete(chat)
                            try? viewContext.save()
                        }
                    } else {
                        self.showSubscription = true
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
//                Text((chat.date ?? Date()).toString())
//                    .font(.footnote)
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
                
                if chat.answer != nil, !smartInfos.isEmpty {
                    // Add machine learning here
                }
                
            }
            
            Text(chat.answer ?? "")
                .textSelection(.enabled)
            
            #warning("Paraphrasing feature will come later")
            if let paraphrase = chat.paraphrase {
                
            }
        }
        .padding()
        .foregroundColor(.accentColor)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke()
        )
    }
}
