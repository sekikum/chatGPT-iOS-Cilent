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
    if apiKey.count < format.count {
      return format
    }
    
    let replacement = "$1\(format)$3"
    var size = (apiKey.count - format.count) / 2
    size = size > format.count ? format.count : size
    let pattern = "^(.{\(size)})(.{1,})(.{\(size)})$"

    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let maskedAPIKey = regex.stringByReplacingMatches(in: apiKey, options: [], range: NSRange(location: 0, length: apiKey.utf16.count), withTemplate: replacement)
    return maskedAPIKey
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
