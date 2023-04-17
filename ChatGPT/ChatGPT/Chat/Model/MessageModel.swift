//
//  MessageModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import Foundation

struct MessageModel: Identifiable, Equatable, Hashable {
  let id = UUID()
  var message: String
  let isUser: Bool
}

class ChatContentGroup: Identifiable {
  static var index: Int = 0
  var title: String
  var message: [MessageModel]
  
  init(message: [MessageModel]) {
    Self.index += 1
    self.title = "Chat \(Self.index)"
    self.message = message
  }
}
