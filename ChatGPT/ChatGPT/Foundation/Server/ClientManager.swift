//
//  ClientManager.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/4/27.
//

import Foundation

class ClientManager {
  static let shared = ClientManager()
  var openAI: OpenAIServer
  
  private init() {
    self.openAI = OpenAIServer(authAPIKey: StorageManager.restoreUser().apiKeySelect)
  }
  
  func updateOpenAI(_ apiKey: String) {
    openAI.updateAPIKey(apiKey)
  }
  
  func sendChatImage(with prompt: String, number: Int, size: String, completionHandler: @escaping (Result<OpenAIImage<ImageResult>, ClientError>) -> Void) {
    openAI.sendChatImage(with: prompt, number: number, size: size, completionHandler: completionHandler)
  }
  
  func sendChat(with messages: [ChatMessage], model: String, maxTokens: Int? = nil, completionHandler: @escaping (Result<OpenAI<MessageResult>, ClientError>) -> Void) {
    openAI.sendChat(with: messages, model: model, completionHandler: completionHandler)
  }
  
  func cancelStreamRequest() {
    openAI.cancelStreamRequest()
  }
}
