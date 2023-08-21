//
//  ChatGPTApp.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/3.
//

import SwiftUI
import UIKit

let quickActionSettings = QuickActionSettings()
var shortcutItemToProcess: UIApplicationShortcutItem?

@main
struct ChatGPTApp: App {
  @Environment(\.scenePhase) var phase
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      HomeView()
        .environmentObject(quickActionSettings)
    }
    .onChange(of: phase) { (newPhase) in
      switch newPhase {
      case .active:
        guard let name = shortcutItemToProcess?.userInfo?["name"] as? String else {
          return
        }
        switch name {
        case "chat":
          quickActionSettings.quickAction = .newChat
        default:
          break
        }
        shortcutItemToProcess = nil
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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    if let shortcutItem = options.shortcutItem {
      shortcutItemToProcess = shortcutItem
    }
    
    let sceneConfiguration = UISceneConfiguration(name: "Custom Configuration", sessionRole: connectingSceneSession.role)
    sceneConfiguration.delegateClass = CustomSceneDelegate.self
    
    return sceneConfiguration
  }
}

class CustomSceneDelegate: UIResponder, UIWindowSceneDelegate {
  func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    shortcutItemToProcess = shortcutItem
  }
}
