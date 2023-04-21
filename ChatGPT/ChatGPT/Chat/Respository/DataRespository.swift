//
//  DataRespository.swift
//  ChatGPT
//
//  Created by cai dongyu on 2023/4/19.
//

import Foundation
import CoreData
import SwiftUI

protocol DataRespository {
  func fetchData() -> [ChatGroup]
  func saveChatGroup(_ content: String) -> ChatGroup
  func saveChatLine(_ group: ChatGroup, content: MessageModel)
  func deleteGroup(_ group: ChatGroup)
  func deleteGroupContains(_ group: ChatGroup)
  func modifyGroup(group: ChatGroup, flag: String)
}

class CoreDataRespository: DataRespository {
  let container: NSPersistentContainer
  
  init() {
    container = NSPersistentContainer(name: "ChatLog")
    container.loadPersistentStores { (description, error) in
      if let _ = error {
        print("Load Core Data Error!")
      }
    }
  }
  
  func saveContext() {
    do {
      try container.viewContext.save()
    } catch {
      let error = error as NSError
      print(error.localizedDescription)
    }
  }
  
  func modifyGroup(group: ChatGroup, flag: String) {
    group.flag = flag
    saveContext()
  }
  
  
  func saveChatGroup(_ content: String) -> ChatGroup {
    let group = ChatGroup(context: container.viewContext, content: content)
    saveContext()
    return group
  }
  
  func saveChatLine(_ group: ChatGroup, content: MessageModel) {
    let entity = ChatLine(context: container.viewContext, content: content)
    group.addToContains(entity)
    saveContext()
  }
  
  func fetchData() -> [ChatGroup] {
    let request = NSFetchRequest<ChatGroup>(entityName: "ChatGroup")
    request.sortDescriptors = [NSSortDescriptor(keyPath: \ChatGroup.timestamp, ascending: true)]
    
    do {
      let groups = try container.viewContext.fetch(request)
      return groups
    }
    catch {
      print(error.localizedDescription)
      return []
    }
  }
  
  func deleteGroup(_ group: ChatGroup) {
    container.viewContext.delete(group)
    saveContext()
  }
  
  func deleteGroupContains(_ group: ChatGroup) {
    if let contains = group.contains {
      group.removeFromContains(contains)
      saveContext()
    }
  }
}
