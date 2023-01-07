//
//  ContentView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/2/23.
//

import SwiftUI

extension View {
    func makeCircleImage(systemName: String) -> some View {
        Image(systemName: systemName)
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke()
            )
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            ChatsView()
                .tabItem {
                    Label("Chats", systemImage: "ellipsis.bubble")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
