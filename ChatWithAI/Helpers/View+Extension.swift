//
//  View+Extension.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/10/23.
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
