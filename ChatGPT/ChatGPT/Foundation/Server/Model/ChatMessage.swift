//
//  ChatMessage.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/21.
//

import Foundation

public enum ChatRole: String, Codable {
  case system, user, assistant
}

public struct ChatMessage: Codable {
  public let role: ChatRole?
  public let content: String?
  
  public init(role: ChatRole?, content: String?) {
    self.role = role
    self.content = content
  }
}

public struct ChatConversation: Encodable {
  let messages: [ChatMessage]
  let model: String
  let maxTokens: Int?
  let stream: Bool = true
  
  enum CodingKeys: String, CodingKey {
    case messages
    case model
    case maxTokens = "max_tokens"
    case stream
  }
}
