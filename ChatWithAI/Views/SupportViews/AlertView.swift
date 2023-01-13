//
//  AlertView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/11/23.
//

import SwiftUI

extension Alert {
    static func subscriptionAlert(action: @escaping (() -> Void)) -> Alert {
        Alert(
            title: Text("Not A Bug"),
            message: Text("Subscribe to unlock all features of the app"),
            dismissButton: .cancel(Text("OK"), action: action)
        )
    }
}
