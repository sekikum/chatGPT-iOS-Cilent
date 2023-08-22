//
//  ChatGPTApp.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/3.
//

import SwiftUI

@main
struct ChatGPTApp: App {
  @Environment(\.scenePhase) var phase
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  private let quickActionSettings = QuickActionSettings.shared
  
  var body: some Scene {
    WindowGroup {
      HomeView()
        .environmentObject(quickActionSettings)
    }
    .onChange(of: phase) { (newPhase) in
      switch newPhase {
      case .active:
        guard let name = quickActionSettings.shortcutItemToProcess?.userInfo?["name"] as? String else {
          return
        }
        switch name {
        case "chat":
          quickActionSettings.quickAction = .newChat
        default:
          break
        }
        quickActionSettings.shortcutItemToProcess = nil
      case .inactive:
        break
      case .background:
        quickActionSettings.addQuickActions()
      @unknown default:
        break
      }
    }
  }
}
