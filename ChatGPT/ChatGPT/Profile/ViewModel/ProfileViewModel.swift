//
//  ProfileViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/14.
//

import Foundation

struct ProfileViewModel {
  func maskToken(_ token: String) -> String {
    let format = "****"
    var number = 4
    if token.count <= 4 {
      return format
    }
    if token.count <= 8 {
      number = (token.count - 4) / 2
    }
    let maskToken = String(token.prefix(number)) + format + String(token.suffix(number))
    return maskToken
  }
  
  func isWhitespaceString(_ str: String) -> Bool {
    let whitespace = CharacterSet.whitespacesAndNewlines
    return str.trimmingCharacters(in: whitespace).isEmpty
  }
  
  func isValidURL(_ url: String) -> Bool {
    if let _ = URL(string: url) {
      return true
    }
    return false
  }
}
