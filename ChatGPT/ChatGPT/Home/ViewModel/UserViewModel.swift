//
//  UserViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import Foundation

class UserViewModel: ObservableObject {
  @Published var user: UserModel
  
  init() {
    user = StorageManager.restoreUser()
  }
  
  func addToken(_ token: String) {
    if user.tokenList.contains(token) {
      user.tokenSelect = token
    } else {
      user.tokenList.append(token)
      if user.tokenList.count == 1 {
        user.tokenSelect = user.tokenList[0]
      }
    }
    Task {
      await StorageManager.storeUser(user)
    }
  }
  
  func deleteToken(_ token: String) {
    user.tokenList = user.tokenList.filter { $0 != token }
    if user.tokenSelect == token {
      if user.tokenList.count == 0 {
        user.tokenSelect = ""
      } else {
        user.tokenSelect = user.tokenList[0]
      }
    }
    Task {
      await StorageManager.storeUser(user)
    }
  }
  
  func addBaseURL(_ url: String) {
    user.baseURL = url
    Task {
      await StorageManager.storeUser(user)
    }
  }
  
  func clearBaseURL() {
    user.baseURL = ""
    Task {
      await StorageManager.storeUser(user)
    }
  }
}
