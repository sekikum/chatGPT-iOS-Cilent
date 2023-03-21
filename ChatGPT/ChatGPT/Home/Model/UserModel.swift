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
  var tokenList: [String]
  var tokenSelect: String
  var modelSelect: String
}
