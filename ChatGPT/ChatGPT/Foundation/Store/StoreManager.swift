//
//  StoreManager.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/14.
//

import Foundation

struct StorageManager {
  static let defaultStand = UserDefaults.standard
  static let USER_KEY = "USER"

  static func restoreUser() -> UserModel {
    guard let data = defaultStand.data(forKey: USER_KEY) else {
      return UserModel(avatar: "Profile-Diu", nickname: "sekikum", tokenList: [], tokenSelect: "")
    }
    guard let user = try? PropertyListDecoder().decode(UserModel.self, from: data) else {
      return UserModel(avatar: "Profile-Diu", nickname: "sekikum", tokenList: [], tokenSelect: "")
    }
    return user
  }

  static func storeUser(_ user: UserModel) async {
    guard let data = try? PropertyListEncoder().encode(user) else {
      return
    }
    defaultStand.set(data, forKey: USER_KEY)
  }
}
