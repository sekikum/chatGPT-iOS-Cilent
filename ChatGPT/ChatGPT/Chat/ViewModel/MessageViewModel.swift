//
//  MessageViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import Foundation

class MessageViewModel: ObservableObject {
  @Published var messageItems: [MessageModel] = []
  @Published var isShowAlert: Bool = false
  @Published var alertInfo: String = ""
  @Published var isShowLoading: Bool = false
  var openAI = OpenAIServer(authToken: "")
  var chatMessageItems: [ChatMessage] = []
  
  init() {
    initOpenAI(StorageManager.restoreUser().tokenSelect)
  }
  
  func initOpenAI(_ token: String) {
    openAI = OpenAIServer(authToken: token)
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
    
    messageItems.append(MessageModel(message: message, isUser: true))
    let chatMessageUser = ChatMessage(role: .user, content: message)
    chatMessageItems.append(chatMessageUser)
    isShowLoading = true
    
    openAI.sendChat(with: chatMessageItems, model: model) { result in
      switch(result) {
      case .failure:
        DispatchQueue.main.async {
          self.isShowLoading = false
          self.isShowAlert = true
          self.alertInfo = NSLocalizedString("Please choose the correct token and baseURL", comment: "")
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
