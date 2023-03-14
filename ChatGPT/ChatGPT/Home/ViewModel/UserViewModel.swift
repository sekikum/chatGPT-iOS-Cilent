//
//  UserViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import Foundation

@MainActor class UserViewModel: ObservableObject {
  @Published var user: UserModel = UserModel(avatar: "Profile-Diu", nickname: "sekikum", tokenList: [], tokenSelect: "")
  
  private static var UsersURL: URL {
    let path = NSHomeDirectory() + "/users.data"
    return URL(fileURLWithPath: path)
  }
  
  init() {
    guard let data = UserDefaults.standard.data(forKey: "USER") else {
      return
    }
    guard let userStored = try? PropertyListDecoder().decode(UserModel.self, from: data) else {
      return
    }
    user = userStored
  }
  
  func storeUser(_ user: UserModel) async {
    guard let data = try? PropertyListEncoder().encode(user) else {
      return
    }
    UserDefaults.standard.set(data, forKey: "USER")
  }
}
