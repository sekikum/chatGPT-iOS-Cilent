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
  var openAI = OpenAISwift(authToken: "")
  var chatMessageItems: [ChatMessage] = []
  
  init() {
    loadMessage()
    openAI = OpenAISwift(authToken: StorageManager.restoreUser().tokenSelect)
  }
  
  func initOpenAI(_ token: String) {
    openAI = OpenAISwift(authToken: token)
  }
  
  func loadMessage() {
    messageItems = chatMessageItems.map({ chatMessage in
      if chatMessage.role == .user {
        return MessageModel(message: chatMessage.content, isUser: true)
      }
      return MessageModel(message: chatMessage.content, isUser: false)
    })
  }
  
  func sendMessage(_ message: String) {
    messageItems.append(MessageModel(message: message, isUser: true))
    let chatMessageUser = ChatMessage(role: .user, content: message)
    chatMessageItems.append(chatMessageUser)

    openAI.sendChat(with: chatMessageItems) { result in
      switch(result) {
      case .failure(let failure):
        print(failure.localizedDescription)
      case .success(let success):
        DispatchQueue.main.async {
          guard let chatMessageSystem = success.choices.first?.message else {
            return
          }
          let message = MessageModel(message: chatMessageSystem.content, isUser: false)
          self.chatMessageItems.append(chatMessageSystem)
          self.messageItems.append(message)
        }
      }
    }
  }
  
  func clearContext() {
    chatMessageItems = []
    messageItems = []
  }
}
