//
//  ChatMessageView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/4/23.
//

import SwiftUI
import WebKit

struct WebViewContainer: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let urlRequest = URLRequest(url: url)
        uiView.load(urlRequest)
    }
    
}

struct WebView: View {
    var url: URL
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            WebViewContainer(url: url)
                .navigationTitle("Search")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

struct ChatMessageView: View {
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var chat: ChatMessage
    
    @State private var showMoreInformation = false
    
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
                    withAnimation {
                        viewContext.delete(chat)
                        try? viewContext.save()
                    }
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                makeCircleImage(systemName: "person.fill.questionmark")
                Spacer()
                Text((chat.date ?? Date()).toString())
                    .font(.footnote)
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
//                    Button {
//                        showMoreInformation.toggle()
//                    } label: {
//                        Text("more")
//                            .font(.caption)
//                    }
//                    .sheet(isPresented: $showMoreInformation) {
//                        SmartInfoView(smartInfos: smartInfos)
//                    }
                }
                
            }
            
            Text(chat.answer ?? "")
        }
        .padding()
        .foregroundColor(.accentColor)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke()
        )
    }
}
