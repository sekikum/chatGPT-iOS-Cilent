//
//  OpenAIModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/21.
//

import Foundation

public enum OpenAIModel {
  case chat(Chat)
  
  public var modelName: String {
    switch self {
    case .chat(let model): return model.rawValue
    }
  }
  
  public enum Chat: String {
    case chatgpt = "gpt-3.5-turbo"
    case chatgpt0301 = "gpt-3.5-turbo-0301"
    case chatgpt4 = "gpt-4"
  }
}
