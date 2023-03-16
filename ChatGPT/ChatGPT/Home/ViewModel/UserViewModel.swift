//
//  UserViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import Foundation

class UserViewModel: ObservableObject {
  @Published var user: UserModel
  @Published var noTokenAdded: Bool
  
  init() {
    user = StorageManager.restoreUser()
    noTokenAdded = StorageManager.restoreUser().tokenList.isEmpty
  }
  
  func addToken(_ token: String) {
    user.tokenList.append(token)
    noTokenAdded = false
    if user.tokenList.count == 1 {
      user.tokenSelect = user.tokenList[0]
    }
    Task {
      await StorageManager.storeUser(user)
    }
  }
}
