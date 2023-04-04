//
//  MessageViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import Foundation
import SwiftUI

class MessageViewModel: ObservableObject {
  @Published var messageItems: [MessageModel] = []
  @Published var isShowAlert: Bool = false
  @Published var alertInfo: String = ""
  @Published var isShowLoading: Bool = false
  var openAI = OpenAIServer(authAPIKey: "")
  var chatMessageItems: [ChatMessage] = []
  
  var group: ChatContentGroup?
  @Published var chatGroups: [ChatContentGroup] = []
  
  init() {
    initOpenAI(StorageManager.restoreUser().apiKeySelect)
    addGroups() 
  }
  
  func addGroups() {
    let group = ChatContentGroup(message: [])
    chatGroups.append(group)
    self.group = group
  }
  
  func saveLineToGroup(_ content: MessageModel) {
    self.group?.message.append(content)
    self.messageItems.append(content)
  }
  
  func setCurrentChat(_ group: ChatContentGroup) {
    self.group = group
    self.messageItems.removeAll()
    for message in group.message {
      self.messageItems.append(message)
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
    default:
      model = .chat(.chatgpt)
    }
    
    self.saveLineToGroup(MessageModel(message: message, isUser: true))
    let chatMessageUser = ChatMessage(role: .user, content: message)
    chatMessageItems.append(chatMessageUser)
    isShowLoading = true
    
    openAI.sendChat(with: chatMessageItems, model: model) { result in
      switch(result) {
      case .failure:
        DispatchQueue.main.async {
          self.isShowLoading = false
          self.isShowAlert = true
          self.alertInfo = NSLocalizedString("Please choose the correct APIKey and BaseURL", comment: "")
        }
      case .success(let success):
        DispatchQueue.main.async {
          guard let chatMessageSystem = success.choices.first?.message else {
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
  }
  
  func trimMessage(_ message: String) -> String {
    var resultMessage = message.trimmingCharacters(in: CharacterSet.whitespaces)
    resultMessage = resultMessage.trimmingCharacters(in: CharacterSet.newlines)
    return resultMessage
  }
}
