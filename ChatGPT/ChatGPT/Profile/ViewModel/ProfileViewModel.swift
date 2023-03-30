//
//  ProfileViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/14.
//

import Foundation

struct ProfileViewModel {
  func maskAPIKey(_ apiKey: String) -> String {
    let format = "****"
    var number = 4
    if apiKey.count <= 4 {
      return format
    }
    if apiKey.count <= 8 {
      number = (apiKey.count - 4) / 2
    }
    let maskAPIKey = String(apiKey.prefix(number)) + format + String(apiKey.suffix(number))
    return maskAPIKey
  }
  
  func trimString(_ string: String) -> String {
    return string.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  func isValidURL(_ url: String) -> Bool {
    if let _ = URL(string: url) {
      return true
    }
    return false
  }
}
