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
      groupCount = self .chatGroups.count
    if groupCount == 0 {
      addGroup()
    }

    initOpenAI(StorageManager.restoreUser().apiKeySelect)  }

  func addGroup() {
    groupCount += 1
    group = saveChatGroup("chat \(groupCount)")
    fetchGroups()
  }
  
  func saveLineToGroup(_ content: MessageModel) {
    if let group = group {
      saveChatLine(group, content: content)
      if content.isUser {
        messageItems.append(content)
      }
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
    var messageString: String = ""
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
    sendMessageItems.append(chatMessageUser)
    isShowLoading = true
    isStreamingMessage = true
    
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
            self.saveSystemMessage(messageString)
          }
          if success.choices?.first?.finishReason != nil {
            self.saveSystemMessage(messageString)
            self.isStreamingMessage = false
          }
          messageString += chatMessageSystem.content ?? ""
          if let _ = chatMessageSystem.role {
            self.messageItems.append(MessageModel(message: messageString, isUser: false))
          } else {
            if self.messageItems.last != nil {
              let updatedMessageItems = MessageModel(message: messageString, isUser: false)
              self.messageItems[self.messageItems.count - 1] = updatedMessageItems
            }
          }
        }
      }
    }
  }
  
  func setErrorData(errorMessage: String) {
    self.isShowLoading = false
    self.isShowAlert = true
    self.alertInfo = NSLocalizedString(errorMessage, comment: "")
    self.isStreamingMessage = false
  }
  
  func saveSystemMessage(_ message: String) {
    self.sendMessageItems.append(ChatMessage(role: .system, content: message))
    self.saveLineToGroup(MessageModel(message: message, isUser: false))
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
