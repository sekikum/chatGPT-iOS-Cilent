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
