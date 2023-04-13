//
//  MessageViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import Foundation
import SwiftUI
import CoreData

class MessageViewModel: ObservableObject {
  @Published var messageItems: [MessageModel] = []
  @Published var isShowAlert: Bool = false
  @Published var alertInfo: String = ""
  @Published var isShowLoading: Bool = false
  var openAI = OpenAIServer(authAPIKey: "")
  var chatMessageItems: [ChatMessage] = []
  
  let container: NSPersistentContainer
  
  @Published var chatGroups: [ChatGroup] = []
  var groupCount: Int = 0
  var group: ChatGroup?
  var groupCountEntity: [ChatGroupCount]?
  
  init() {
    container = NSPersistentContainer(name: "ChatLog")
    container.loadPersistentStores { (description, error) in
      if let _ = error {
        print("Load Core Data Error!")
      }
    }
    fetchGroups()
    fetchGroupsCount()
    initOpenAI(StorageManager.restoreUser().apiKeySelect)
    
    if self.groupCount == 0 {
      self.groupCount += 1
      self.group = saveChatGroup("chat \(self.groupCount)")
      fetchGroups()
    }
  }
  
  func addGroups() {
    self.groupCount += 1
    self.group = saveChatGroup("chat \(self.groupCount)")
    fetchGroups()
  }
  
  func saveLineToGroup(_ content: MessageModel) {
    if let group = self.group {
      saveChatLine(group, content: content)
      self.messageItems.append(content)
      
    }
  }

  func setCurrentChat(_ group: ChatGroup) {
    self.group = group
    self.messageItems.removeAll()

    if let contains = group.contains {
      for line in contains.array {
        if let l = line as? ChatLine {
          self.messageItems.append(MessageModel(message: l.message ?? "", isUser: l.isUser))
        }
      }
    }
  }
  
  func initOpenAI(_ apiKey: String) {
    openAI = OpenAIServer(authAPIKey: apiKey)
  }
  
  func sendMessage(_ message: String, _ modelString: String) {
    var model: OpenAIModel
    
    if message.isEmpty {
      isShowAlert = true
      alertInfo = NSLocalizedString("Message cannot be empty", comment: "")
      return
    }
    
    switch(modelString) {
    case "gpt-3.5-0310":
      model = .chat(.chatgpt0301)
    case "gpt-3.5":
      model = .chat(.chatgpt)
    case "gpt-4":
      model = .chat(.chatgpt4)
    default:
      model = .chat(.chatgpt)
    }
    
    self.saveLineToGroup(MessageModel(message: message, isUser: true))
    let chatMessageUser = ChatMessage(role: .user, content: message)
    chatMessageItems.append(chatMessageUser)
    isShowLoading = true
    
    openAI.sendChat(with: chatMessageItems, model: model) { result in
      switch(result) {
      case .failure(let failure):
        self.isShowLoading = false
        self.isShowAlert = true
        self.alertInfo = NSLocalizedString(failure.message, comment: "")
      case .success(let success):
        if let error = success.error {
          self.isShowLoading = false
          self.isShowAlert = true
          self.alertInfo = NSLocalizedString(error.code.formatErrorCode, comment: "")
        } else {
          guard let chatMessageSystem = success.choices?.first?.message else {
            return
          }
          let message = MessageModel(message: self.trimMessage(chatMessageSystem.content), isUser: false)
          self.chatMessageItems.append(chatMessageSystem)
          self.isShowLoading = false
          self.saveLineToGroup(message)
        }
      }
    }
  }
  
  func clearContext() {
    chatMessageItems = []
    messageItems = []
    deleteChatGroup()
    fetchGroups()
  }
  
  func clearScreen() {
    chatMessageItems = []
    messageItems = []
    
  }
  
  func trimMessage(_ message: String) -> String {
    var resultMessage = message.trimmingCharacters(in: CharacterSet.whitespaces)
    resultMessage = resultMessage.trimmingCharacters(in: CharacterSet.newlines)
    return resultMessage
  }
}

extension MessageViewModel {
  func saveContext() {
    do {
      try container.viewContext.save()
    } catch {
      let error = error as NSError
      print(error.localizedDescription)
    }
  }

  func saveChatGroup(_ content: String) -> ChatGroup {
    let group = ChatGroup(context: container.viewContext, content: content, index: self.groupCount)
    saveContext()
    return group
  }

  func saveChatLine(_ group: ChatGroup, content: MessageModel) {
    let entity = ChatLine(context: container.viewContext, content: content)
    group.addToContains(entity)
    saveContext()
  }

  func fetchGroups() {
    let request = NSFetchRequest<ChatGroup>(entityName: "ChatGroup")
    request.sortDescriptors = [NSSortDescriptor(keyPath: \ChatGroup.timestamp, ascending: true)]
    
    do {
      chatGroups = try container.viewContext.fetch(request)
    }
    catch {
      print(error.localizedDescription)
    }
  }

  func fetchGroupsCount() {
    var index: Int32 = 0
    for group in chatGroups {
      if index < group.index {
        index = group.index
      }
    }
    self.groupCount = Int(index)
    print(self.groupCount)
  }

  func deleteChatGroup() {
    if let group = self.group,
       let contains = group.contains {
      for item in contains.array {
        if let i = item as? ChatLine {
          self.container.viewContext.delete(i)
        }
      }
      saveContext()
    }
  }
  
}

extension ChatGroup {
  convenience init(context: NSManagedObjectContext, content: String, index: Int) {
    self.init(context: context)
    self.flag = content
    self.index = Int32(index)
    self.timestamp = Date()
  }
  
}

extension ChatLine {
  convenience init(context: NSManagedObjectContext, content: MessageModel) {
    self.init(context: context)
    self.isUser = content.isUser
    self.message = content.message
    self.id = content.id
  }
}
