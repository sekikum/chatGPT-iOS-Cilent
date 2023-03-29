//
//  Model.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/28.
//

import Foundation

public struct ChatImageModel: Encodable {
  let prompt: String
  let n: Int
  let size: String
}
