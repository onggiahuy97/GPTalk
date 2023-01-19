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
    
    @ObservedObject var chat: ChatMessage
    
    @State private var hasAnswer = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                makeCircleImage(systemName: "person.fill.questionmark")
                
                Spacer()
                
                Text((chat.date ?? Date()).toString())
                    .font(.caption)
                
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
