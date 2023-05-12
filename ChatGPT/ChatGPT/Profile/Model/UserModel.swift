//
//  UserModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import Foundation

struct UserModel: Codable {
  var avatar: String = "Profile-User"
  var nickname: String = "sekikum"
  var apiKeyList: [String] = []
  var apiKeySelect: String = ""
  var modelSelect: String = OpenAIModel.Chat.chatgpt.rawValue
  var baseURL: String = ""
}
