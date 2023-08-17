//
//  OpenAIServerMock.swift
//  ChatGPTTests
//
//  Created by Wenyan Zhao on 2023/5/15.
//

@testable import ChatGPT
import Foundation

class OpenAIServerMock: OpenAIServerProtocol {
  var isCancelStreamRequestCalled: Bool = false
  var isSendChatImageCalled: Bool = false
  
  func updateAPIKey(_ apiKey: String) {
    
  }
  
  func sendChatImage(with prompt: String, number: Int, size: String, completionHandler: @escaping (Result<ChatGPT.OpenAIImage<ChatGPT.ImageResult>, ChatGPT.ClientError>) -> Void) {
    isSendChatImageCalled = true
  }
  
  func sendChat(with messages: [ChatGPT.ChatMessage], model: String, maxTokens: Int?, completionHandler: @escaping (Result<ChatGPT.OpenAI<ChatGPT.MessageResult>, ChatGPT.ClientError>) -> Void) {
    
  }
  
  func cancelStreamRequest() {
    isCancelStreamRequestCalled = true
  }
}
