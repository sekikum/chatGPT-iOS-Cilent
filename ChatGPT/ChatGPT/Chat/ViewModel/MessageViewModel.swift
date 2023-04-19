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
  @Published var isStreamingMessage: Bool = false
  var openAI = OpenAIServer(authAPIKey: "")
  var sendMessageItems: [ChatMessage] = []
  
  let container: NSPersistentContainer
  @Published var chatGroups: [ChatGroup] = []
  var groupCount: Int = 0
  var group: ChatGroup?
  
  init() {
    container = NSPersistentContainer(name: "ChatLog")
    container.loadPersistentStores { (description, error) in
      if let _ = error {
        print("Load Core Data Error!")
      }
    }
    fetchGroups()
    
    if let first = self.chatGroups.first {
      setCurrentChat(first)
    }
    groupCount = self.chatGroups.count
    if groupCount == 0 {
      addGroup()
    }
    
    initOpenAI(StorageManager.restoreUser().apiKeySelect)
  }
  
  func addGroup() {
    groupCount += 1
    group = saveChatGroup("chat \(groupCount)")
    fetchGroups()
  }
  
  func saveLineToGroup() {
    guard let content = messageItems.last else {
      return
    }
    if let group = group {
      saveChatLine(group, content: content)
    }
  }
  
  func setCurrentChat(_ group: ChatGroup) {
    self.group = group
    messageItems.removeAll()
    sendMessageItems.removeAll()
    
    if let contains = group.contains {
      for line in contains.array {
        if let line = line as? ChatLine {
          messageItems.append(MessageModel(message: line.message ?? "", isUser: line.isUser))
          sendMessageItems.append(ChatMessage(role: line.isUser ? .user : .system, content: line.message ?? ""))
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
    
    updateUserMessage(message)
    isShowLoading = true
    isStreamingMessage = true
    
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
    
    openAI.sendChat(with: sendMessageItems, model: model) { result in
      switch(result) {
      case .failure(let failure):
        self.setErrorData(errorMessage: failure.message)
      case .success(let success):
        if let error = success.error {
          self.setErrorData(errorMessage: error.code.replaceUnderlineToWhiteSpaceAndCapitalized)
        } else {
          self.isShowLoading = false
          guard let chatMessageSystem = success.choices?.first?.delta else {
            return
          }
          if !self.isStreamingMessage {
            self.openAI.streamRequest?.cancel()
            self.saveLineToGroup()
          }
          if success.choices?.first?.finishReason != nil {
            self.isStreamingMessage = false
            self.saveLineToGroup()
          }
          self.updateSystemMessage(chatMessageSystem)
        }
      }
    }
  }
  
  func updateSystemMessage(_ message: ChatMessage) {
    if message.role != nil {
      messageItems.append(MessageModel(message: "", isUser: false))
    } else {
      if let messageItem = messageItems.last {
        var messageString = messageItem.message
        messageString += message.content ?? ""
        let updatedMessageItems = MessageModel(message: messageString, isUser: false)
        messageItems[messageItems.count - 1] = updatedMessageItems
      }
    }
    sendMessageItems = convertToChatMessages(from: messageItems)
  }
  
  func updateUserMessage(_ messageString: String) {
    messageItems.append(MessageModel(message: messageString, isUser: true))
    sendMessageItems = convertToChatMessages(from: messageItems)
    saveLineToGroup()
  }
  
  func convertToChatMessages(from messageModels: [MessageModel]) -> [ChatMessage] {
    return messageModels.map { messageModel in
      let role: ChatRole
      if messageModel.isUser {
        role = .user
      } else {
        role = .system
      }
      return ChatMessage(role: role, content: messageModel.message)
    }
  }
  
  func setErrorData(errorMessage: String) {
    isShowLoading = false
    isShowAlert = true
    alertInfo = NSLocalizedString(errorMessage, comment: "")
    isStreamingMessage = false
  }
  
  func clearContext() {
    sendMessageItems = []
    messageItems = []
    deleteChatGroup()
    fetchGroups()
  }
  
  func clearScreen() {
    sendMessageItems = []
    messageItems = []
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
    let group = ChatGroup(context: container.viewContext, content: content)
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
  
  func deleteChatGroup() {
    if let group = self.group,
       let contains = group.contains {
      self.group?.removeFromContains(contains)
      saveContext()
    }
  }
}

extension ChatGroup {
  convenience init(context: NSManagedObjectContext, content: String) {
    self.init(context: context)
    self.flag = content
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
