//
//  UserViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import Foundation

class UserViewModel: ObservableObject {
  @Published var user: UserModel = UserModel(avatar: "Profile-Diu", nickname: "sekikum", tokenList: [], tokenSelect: "")
}
