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
  static let IMAGE_SET_KEY = "IMAGE_SET"

  static func restoreUser() -> UserModel {
    guard let data = defaultStand.data(forKey: USER_KEY) else {
      return UserModel(avatar: "Profile-User", nickname: "sekikum", apiKeyList: [], apiKeySelect: "", modelSelect: "gpt-3.5", baseURL: "")
    }
    guard let user = try? PropertyListDecoder().decode(UserModel.self, from: data) else {
      return UserModel(avatar: "Profile-User", nickname: "sekikum", apiKeyList: [], apiKeySelect: "", modelSelect: "gpt-3.5", baseURL: "")
    }
    return user
  }

  static func storeUser(_ user: UserModel) async {
    guard let data = try? PropertyListEncoder().encode(user) else {
      return
    }
    defaultStand.set(data, forKey: USER_KEY)
  }
  
  static func restoreImageSet() -> ImageSetModel {
    guard let data = defaultStand.data(forKey: IMAGE_SET_KEY) else {
      return ImageSetModel(number: 1, size: "256x256")
    }
    guard let imageSet = try? PropertyListDecoder().decode(ImageSetModel.self, from: data) else {
      return ImageSetModel(number: 1, size: "256x256")
    }
    return imageSet
  }
  
  static func storeImageSet(_ imageSet: ImageSetModel) async {
    guard let data = try? PropertyListEncoder().encode(imageSet) else {
      return
    }
    defaultStand.set(data, forKey: IMAGE_SET_KEY)
  }
}
