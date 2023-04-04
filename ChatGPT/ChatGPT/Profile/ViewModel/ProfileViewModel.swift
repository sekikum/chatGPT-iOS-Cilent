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
    var size = 4
    
    if apiKey.count <= format.count {
      return format
    }
    if apiKey.count <= 2 * size + format.count {
      size = (apiKey.count - size) / 2
    }
    let maskAPIKey = String(apiKey.prefix(size)) + format + String(apiKey.suffix(size))
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
