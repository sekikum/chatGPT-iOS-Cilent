//
//  MessageViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import Foundation
import OpenAISwift

class MessageViewModel: ObservableObject {
  @Published var messageItems: [MessageModel] = []
  @Published var isShowAlert: Bool = false
  @Published var alertInfo: String = ""
  @Published var isShowLoading: Bool = false
  var openAI = OpenAISwift(authToken: "")
  var chatMessageItems: [ChatMessage] = []
  
  init() {
    initOpenAI(StorageManager.restoreUser().tokenSelect)
  }
  
  func initOpenAI(_ token: String) {
    openAI = OpenAISwift(authToken: token)
  }
  
  func sendMessage(_ message: String) {
    if message.isEmpty {
      isShowAlert = true
      alertInfo = "Message cannot be empty"
      return
    }
    
    messageItems.append(MessageModel(message: message, isUser: true))
    let chatMessageUser = ChatMessage(role: .user, content: message)
    chatMessageItems.append(chatMessageUser)
    isShowLoading = true
    
    openAI.sendChat(with: chatMessageItems) { result in
      switch(result) {
      case .failure:
        DispatchQueue.main.async {
          self.isShowLoading = false
          self.isShowAlert = true
          self.alertInfo = "Please choose the correct token"
        }
      case .success(let success):
        DispatchQueue.main.async {
          guard let chatMessageSystem = success.choices.first?.message else {
            return
          }
          let message = MessageModel(message: self.trimMessage(chatMessageSystem.content), isUser: false)
          self.chatMessageItems.append(chatMessageSystem)
          self.messageItems.append(message)
          self.isShowLoading = false
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
