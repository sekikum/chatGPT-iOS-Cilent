//
//  ChatMainViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import Foundation
import SwiftUI

class ChatMainViewModel: ObservableObject {
  @Published var messageItems: [MessageModel] = []
  @Published var isShowAlert: Bool = false
  @Published var alertInfo: String = ""
  @Published var isShowLoading: Bool = false
  @Published var isStreamingMessage: Bool = false
  @Published var prompt: String = ""
  var sendMessageItems: [ChatMessage] = []
  var group: ChatGroup
  let dataRepository: DataRepository

  init(group: ChatGroup, repository: DataRepository) {
    self.sendMessageItems = []
    self.group = group
    self.dataRepository = repository
    setCurrentChat(group)
  }

  func setCurrentChat(_ group: ChatGroup) {
    self.prompt = group.prompt ?? ""
    messageItems.removeAll()

    if let contains = group.contains {
      for message in contains.array {
        if let message = message as? Message {
          messageItems.append(MessageModel(message: message.message ?? "", isUser: message.isUser))
          sendMessageItems.append(ChatMessage(role: message.isUser ? .user : .system, content: message.message ?? ""))
        }
      }
    }
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

    ClientManager.shared.sendChat(with: sendMessageItems, model: model) { result in
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
            ClientManager.shared.cancelStreamRequest()
            self.saveMessageToGroup()
          }
          if success.choices?.first?.finishReason != nil {
            self.isStreamingMessage = false
            self.saveMessageToGroup()
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
    saveMessageToGroup()
  }

  func convertToChatMessages(from messageModels: [MessageModel]) -> [ChatMessage] {
    var chatMessages: [ChatMessage] = []
    if !prompt.isEmpty {
      chatMessages.append(ChatMessage(role: .assistant, content: prompt))
    }
    let convertedMessages = messageModels.map { messageModel in
      let role: ChatRole = messageModel.isUser ? .user : .system
      return ChatMessage(role: role, content: messageModel.message)
    }
    chatMessages.append(contentsOf: convertedMessages)
    return chatMessages
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
    dataRepository.clearChatGroupContext(group)
  }

  func saveMessageToGroup() {
    guard let content = messageItems.last else {
      return
    }
    dataRepository.saveMessage(group, content: content)
  }

  func savePrompt() {
    dataRepository.savePrompt(group, content: prompt)
  }
  
  func cancelStreaming() {
    isStreamingMessage = false
  }
  
  func getGroupTitle() -> String {
    return group.flag ?? "unkown"
  }
}
