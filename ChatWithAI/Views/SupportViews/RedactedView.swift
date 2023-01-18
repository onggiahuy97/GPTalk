//
//  RedactedView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/17/23.
//

import SwiftUI

struct RedactedView: View {
    @State private var animated = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Placeholder - placeholder")
            Text("Placeholder")
        }
        .redacted(reason: .placeholder)
        .foregroundStyle(
            .linearGradient(
                colors: [.gray, .gray.opacity(0.5)],
                startPoint: .leading,
                endPoint: animated ? .trailing : .leading)
        )
        .animation(.easeOut(duration: 2).repeatForever(autoreverses: false), value: animated)
        .onAppear { animated.toggle() }
    }
}
