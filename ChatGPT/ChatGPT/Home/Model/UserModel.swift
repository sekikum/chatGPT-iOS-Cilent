//
//  UserModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import Foundation

struct UserModel: Codable {
  var avatar: String
  var nickname: String
  var apiKeyList: [String]
  var apiKeySelect: String
  var modelSelect: String
  var baseURL: String
}
