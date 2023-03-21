//
//  OpenAIModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/21.
//

import Foundation

public enum OpenAIModel {
  case gpt3(GPT3)
  case chat(Chat)
  
  public var modelName: String {
    switch self {
    case .gpt3(let model): return model.rawValue
    case .chat(let model): return model.rawValue
    }
  }
  
  public enum GPT3: String {
    case davinci = "text-davinci-003"
    case curie = "text-curie-001"
    case babbage = "text-babbage-001"
    case ada = "text-ada-001"
  }
  
  public enum Chat: String {
    case chatgpt = "gpt-3.5-turbo"
  }
}
