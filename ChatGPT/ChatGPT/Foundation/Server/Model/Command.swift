//
//  Command.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/21.
//

import Foundation

struct Command: Encodable {
  let prompt: String
  let model: String
  let maxTokens: Int
  let temperature: Double
  
  enum CodingKeys: String, CodingKey {
    case prompt
    case model
    case maxTokens = "max_tokens"
    case temperature
  }
}

