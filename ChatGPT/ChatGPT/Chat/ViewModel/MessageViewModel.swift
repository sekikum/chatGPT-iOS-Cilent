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
  @Published var isStreamingMessage: Bool = false
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
    if content.isUser {
      self.messageItems.append(content)
    }
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
    chatMessageItems.append(chatMessageUser)
    isShowLoading = true
    isStreamingMessage = true
    
    openAI.sendChat(with: chatMessageItems, model: model) { result in
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
            self.chatMessageItems.append(ChatMessage(role: .system, content: messageString))
            self.saveLineToGroup(MessageModel(message: messageString, isUser: false))
          }
          if success.choices?.first?.finish_reason != nil {
            self.chatMessageItems.append(ChatMessage(role: .system, content: messageString))
            self.saveLineToGroup(MessageModel(message: messageString, isUser: false))
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
  
  func clearContext() {
    chatMessageItems = []
    messageItems = []
  }
}
