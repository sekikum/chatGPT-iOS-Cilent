//
//  Action.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/8/18.
//

import UIKit

class QuickActionSettings: ObservableObject {
  static let shared = QuickActionSettings()
  
  enum QuickAction: Hashable {
    case newChat
  }
  
  @Published var quickAction: QuickAction? = nil
  var shortcutItemToProcess: UIApplicationShortcutItem? = nil
  
  func addQuickActions() {
    var newChatUserInfo: [String: NSSecureCoding] {
      return ["name" : "chat" as NSSecureCoding]
    }
    
    UIApplication.shared.shortcutItems = [
      UIApplicationShortcutItem(
        type: "New Chat",
        localizedTitle: "New Chat",
        localizedSubtitle: "",
        icon: UIApplicationShortcutIcon(systemImageName: "plus.circle"),
        userInfo: newChatUserInfo
      )
    ]
  }
}
