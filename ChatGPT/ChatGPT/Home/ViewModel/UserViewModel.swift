//
//  UserViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import Foundation

class UserViewModel: ObservableObject {
  @Published var user: UserModel = UserModel(avatar: "Profile-Diu", nickname: "sekikum", tokenList: [], tokenSelect: "")
  
  private static var UsersURL: URL {
    let path = NSHomeDirectory() + "/users.data"
    return URL(fileURLWithPath: path)
  }
  
  init() {
    DispatchQueue.global().async {
      if let data = try? Data(contentsOf: UserViewModel.UsersURL, options: []) {
        let user = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! UserModel
        DispatchQueue.main.async {
          self.user = user
        }
      }
    }
  }
  
  func storeUserWith(user: UserModel) {
    DispatchQueue.global().async {
      do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: self.user, requiringSecureCoding: false)
        try data.write(to: UserViewModel.UsersURL)
        DispatchQueue.main.async {
          self.user = user
        }
      } catch {
        
      }
    }
  }
}
