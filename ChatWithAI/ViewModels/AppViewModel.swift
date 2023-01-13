//
//  AppViewModel.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/4/23.
//

import Foundation

struct URLItem: Identifiable {
    var id: String { url.absoluteString }
    var url: URL
}

class AppViewModel: ObservableObject {
    private let userDefault = UserDefaults.standard
    
    @Published var showSubscription = false 
    @Published var isFirstLauch: Bool = false
    @Published var urlItem: URLItem?
    
    init() {
        checkIfHasSeenBefore()
    }
    
    func checkIfHasSeenBefore() {
        if userDefault.bool(forKey: "lauchedBefore") == false {
            isFirstLauch = true
            userDefault.set(true, forKey: "lauchedBefore")
        } else {
            isFirstLauch = false
        }
    }
}
