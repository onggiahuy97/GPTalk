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
  @Published var fontSize: CGFloat = 18 {
    didSet {
      userDefault.set(Int(fontSize), forKey: "fontSize")
    }
  }
    
    init() {
      checkIfHasSeenBefore()
      
      let fontSize = userDefault.integer(forKey: "fontSize")
      self.fontSize = fontSize == 0 ? 18.0 : CGFloat(fontSize)
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
