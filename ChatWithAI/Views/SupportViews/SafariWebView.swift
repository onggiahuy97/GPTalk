//
//  SafariWebView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/10/23.
//

import SwiftUI

#if os(iOS)

import SafariServices

struct SafariWebView: UIViewControllerRepresentable {
    var url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safari = SFSafariViewController(url: url)
        return safari
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}

struct WebView: View {
    var url: URL
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        SafariWebView(url: url)
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
