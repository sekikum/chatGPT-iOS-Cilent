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
  case image
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
    case .image:
      return "/v1/images/generations"
    }
  }
  
  var method: String {
    switch self {
    case .completions, .edits, .chat, .image:
      return "POST"
    }
  }
  
  func baseURL() -> String {
    switch self {
    case .completions, .edits, .chat, .image:
      let baseURL = StorageManager.restoreUser().baseURL
      if baseURL.isEmpty {
        return "https://api.openai.com"
      }
      return baseURL
    }
  }
}
