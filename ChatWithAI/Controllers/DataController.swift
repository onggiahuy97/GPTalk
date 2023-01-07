//
//  DataController.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/3/23.
//

import Foundation
import CoreData

class DataController {
    
    static let shared = DataController()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Main")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load persistent store \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    init() {}
    
    
    
}
