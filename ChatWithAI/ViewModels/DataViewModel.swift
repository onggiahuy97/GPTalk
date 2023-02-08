//
//  DataViewModel.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/30/23.
//

import Foundation
import CoreData

class DataViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
  private let viewContext: NSManagedObjectContext
  private let fetchResultedController: NSFetchedResultsController<ChatMessage>
  
  @Published var chats = [ChatMessage]()
  @Published var favoriteChats = [ChatMessage]()
  
  init(context: NSManagedObjectContext) {
    self.viewContext = context
    
    let request: NSFetchRequest<ChatMessage> = ChatMessage.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \ChatMessage.date, ascending: true)]
    
    fetchResultedController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    
    super.init()
    
    fetchResultedController.delegate = self
    
    fetchData()
  }
  
  func deleteAllNotFavoriteChats() {
    let filteredChat = chats.filter { !favoriteChats.contains($0) }
    filteredChat.forEach {
      viewContext.delete($0)
    }
    try? viewContext.save()
  }
  
  private func fetchData() {
    do {
      try fetchResultedController.performFetch()
      chats = fetchResultedController.fetchedObjects ?? []
      favoriteChats = chats.filter { $0.isFavorite }
    } catch {
      print("Failed to fetch chat message with error: \(error.localizedDescription)")
    }
  }
  
  internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    fetchData()
  }
}
