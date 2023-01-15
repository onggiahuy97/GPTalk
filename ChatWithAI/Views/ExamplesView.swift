//
//  ExamplesView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/13/23.
//

import SwiftUI

struct ExampleRowView: View {
    let example: Example
    
    var body: some View {
        NavigationLink {
            Form {
                if !example.description.isEmpty {
                    Section {} footer: {
                        Text(example.description)
                    }
                }
                Section("Prompt") {
                    Text(example.prompt)
                }
                Section("Sample reponse") {
                    Text(example.reponse)
                }
            }
            .navigationTitle(example.title)
        } label: {
            Label(example.title, systemImage: example.systemImage)
        }
    }
}

struct ExamplesView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            Form {
                Section {} footer: {
                    Text("We recommend using **Davinci** model to get the most powerful answer")
                }
                Section {
                    ForEach(Example.list) { example in
                        ExampleRowView(example: example)
                    }
                }
            }
            .navigationTitle("Examples")
            .toolbar {
                makeDoneButton(_dismiss)
            }
        }
    }
}

