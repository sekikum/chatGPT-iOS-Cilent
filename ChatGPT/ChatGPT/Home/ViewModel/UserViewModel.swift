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
}
