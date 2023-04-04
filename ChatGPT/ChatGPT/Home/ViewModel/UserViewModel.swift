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
  
  func addAPIKey(_ apiKey: String) {
    if user.apiKeyList.contains(apiKey) {
      user.apiKeySelect = apiKey
    } else {
      user.apiKeyList.append(apiKey)
      if user.apiKeyList.count == 1 {
        user.apiKeySelect = user.apiKeyList[0]
      }
    }
    Task {
      await StorageManager.storeUser(user)
    }
  }
  
  func deleteAPIKey(_ apiKey: String) {
    user.apiKeyList = user.apiKeyList.filter { $0 != apiKey }
    if user.apiKeySelect == apiKey {
      if user.apiKeyList.count == 0 {
        user.apiKeySelect = ""
      } else {
        user.apiKeySelect = user.apiKeyList[0]
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
