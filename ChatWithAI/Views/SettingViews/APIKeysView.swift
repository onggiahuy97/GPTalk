//
//  APIKeysView.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/10/23.
//

import SwiftUI
import LocalAuthentication

struct APIKeysView: View {
    @State private var isUnlocked = false
    
    var body: some View {
        Group {
            if isUnlocked {
                Text("Get subscription...")
            } else {
                Button("Click here to unlock") {
                    authenticate()
                }
                .bold()
                .padding()
                .foregroundColor(.blue)
            }
        }
        .onAppear(perform: authenticate)
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authentication Keys API Purposes"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { grant, error in
                if grant {
                    isUnlocked = true
                } else {
                    
                }
            }
        } else {
            
        }
    }
}
