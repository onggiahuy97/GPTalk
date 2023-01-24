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
      
      Button(role: .destructive, action: deleteChat) {
        Label("Delete", systemImage: "trash")
      }
      
    } label: {
      Image(systemName: "ellipsis")
    }
  }
  
  private func deleteChat() {
    DispatchQueue.main.async {
      viewContext.delete(chat)
      try? viewContext.save()
    }
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center) {
        
        makeCircleImage(systemName: "person.fill.questionmark")
        
        Spacer()
        
        Text((chat.date ?? Date()).toString())
          .font(.caption)
        
        menuView
        
      }
      
      Text(chat.question ?? "")
      
      Divider()
        .padding(.bottom, 5)
      
      HStack(alignment: .top, spacing: 10) {
        
        makeCircleImage(systemName: "pc")
        
        Spacer()
        
      }
      
      if let answer = chat.answer {
        Text(answer)
          .textSelection(.enabled)
      } else {
        RedactedView()
      }
      
    }
    .padding()
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke()
        .foregroundColor(.secondary)
    )
  }
}
