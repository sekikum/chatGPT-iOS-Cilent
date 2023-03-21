//
//  API.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/21.
//

import Foundation

enum OpenAIEndpoint {
  case completions
  case edits
  case chat
}

extension OpenAIEndpoint {
  var path: String {
    switch self {
    case .completions:
      return "/v1/completions"
    case .edits:
      return "/v1/edits"
    case .chat:
      return "/v1/chat/completions"
    }
  }
  
  var method: String {
    switch self {
    case .completions, .edits, .chat:
      return "POST"
    }
  }
  
  func baseURL() -> String {
    switch self {
    case .completions, .edits, .chat:
      return "https://api.openai.com"
    }
  }
}
