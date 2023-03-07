//
//  ChatGPTApp.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/3.
//

import SwiftUI
import IQKeyboardManagerSwift

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    IQKeyboardManager.shared.enable = true
    return true
  }
}

@main
struct ChatGPTApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
