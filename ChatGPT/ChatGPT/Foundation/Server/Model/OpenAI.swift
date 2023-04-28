//
//  OpenAI.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/21.
//

import Foundation

public protocol Payload: Codable { }

public struct OpenAI<T: Payload>: Codable {
  public let choices: [T]?
  public let error: OpenAIErrorModel?
}

public struct MessageResult: Payload, Codable {
  public let delta: ChatMessage
  public let finishReason: String?
  
  enum CodingKeys: String, CodingKey {
    case delta
    case finishReason = "finish_reason"
  }
}
