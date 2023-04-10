//
//  OpenAIError.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/4/7.
//

import Foundation

enum OpenAIError: Error {
  case genericError
  case apiError(error: OpenAIErrorResult)
}

struct OpenAIErrorResult: Codable {
  var error: OpenAIErrorResultModel
}

struct OpenAIErrorResultModel: Codable {
  var id = UUID()
  var message: String
  let type: String
  let code: String
  
  private enum CodingKeys: String, CodingKey {
    case message, type, code
  }
}
