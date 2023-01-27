//
//  ChatMessageView.swift
//  MacGPTalk
//
//  Created by Huy Ong on 1/18/23.
//

import SwiftUI

struct ChatMessageView: View {
  @Environment(\.managedObjectContext) var viewContext
  
  @EnvironmentObject var appVM: AppViewModel
  @EnvironmentObject var chatVM: ChatViewModel
  
  @ObservedObject var chat: ChatMessage
  
  @State private var hasAnswer = false
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center) {
        
        Spacer()
        
        Text((chat.date ?? Date()).toString())
          .font(.caption)
        
      }
      
      Text(chat.question ?? "")
        .bold()
      #if os(macOS)
        .onTapGesture {
          chatVM.text = chat.question ?? ""
        }
      #endif
      
      Divider()
        .padding(.bottom, 5)
      
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
