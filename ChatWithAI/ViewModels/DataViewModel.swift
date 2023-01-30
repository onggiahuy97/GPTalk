//
//  DataViewModel.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/30/23.
//

import Foundation
import CoreData

class DataViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
  private let context: NSManagedObjectContext
  private let fetchResultedController: NSFetchedResultsController<ChatMessage>
  
  @Published var chats = [ChatMessage]()
  
  var favoritesChat: [ChatMessage] {
    chats.filter { $0.isFavorite }
  }
  
  init(context: NSManagedObjectContext) {
    self.context = context
    
    let request: NSFetchRequest<ChatMessage> = ChatMessage.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \ChatMessage.date, ascending: true)]
    
    fetchResultedController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    
    super.init()
    
    fetchResultedController.delegate = self
    
    fetchData()
  }
  
  private func fetchData() {
    do {
      try fetchResultedController.performFetch()
      chats = fetchResultedController.fetchedObjects ?? []
    } catch {
      print("Failed to fetch chat message with error: \(error.localizedDescription)")
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    fetchData()
  }
}
