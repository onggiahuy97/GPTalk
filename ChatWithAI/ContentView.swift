//
//  ContentView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/2/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appVM: AppViewModel
    
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
        .sheet(isPresented: $appVM.isFirstLauch) {
            InformationView()
                .onDisappear(perform: appVM.checkIfHasSeenBefore)
        }
    }
}
