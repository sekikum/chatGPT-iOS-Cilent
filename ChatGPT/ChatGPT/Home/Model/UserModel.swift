//
//  UserModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import Foundation

class UserModel: NSObject, NSCoding {
  var avatar: String
  var nickname: String
  var tokenList: [String]
  var tokenSelect: String
  
  required init?(coder: NSCoder) {
    avatar = coder.decodeObject(forKey: "avatar") as! String
    nickname = coder.decodeObject(forKey: "nickname") as! String
    tokenList = coder.decodeObject(forKey: "tokenList") as! [String]
    tokenSelect = coder.decodeObject(forKey: "tokenSelect") as! String
  }
  
  init(avatar: String, nickname: String, tokenList: [String], tokenSelect: String) {
    self.avatar = avatar
    self.nickname = nickname
    self.tokenList = tokenList
    self.tokenSelect = tokenSelect
  }
  
  func encode(with coder: NSCoder) {
    coder.encode(avatar, forKey: "avatar")
    coder.encode(nickname, forKey: "nickname")
    coder.encode(tokenList, forKey: "tokenList")
    coder.encode(tokenSelect, forKey: "tokenSelect")
  }
}
