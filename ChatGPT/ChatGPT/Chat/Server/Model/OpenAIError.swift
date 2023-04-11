//
//  OpenAIError.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/4/7.
//

import Foundation

struct OpenAIError: Error {
  var type: String
  var message: String
}

public struct OpenAIErrorResultModel: Equatable, Codable, Hashable {
  var message: String
  let type: String
  let code: String
  
  private enum CodingKeys: String, CodingKey {
    case message, type, code
  }
}
