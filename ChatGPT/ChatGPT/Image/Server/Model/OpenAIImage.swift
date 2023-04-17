//
//  OpenAIImage.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/28.
//

import Foundation

public struct OpenAIImage<T: Payload>: Codable {
  public let data: [T]?
  public let error: OpenAIErrorModel?
}

public struct ImageResult: Payload {
  public let url: String
}
