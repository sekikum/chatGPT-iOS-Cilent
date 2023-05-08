//
//  ClientManager.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/4/27.
//

import Foundation

class ClientManager {
  static let shared = ClientManager()
  var openAI: OpenAIServer
  
  private init() {
    self.openAI = OpenAIServer(authAPIKey: StorageManager.restoreUser().apiKeySelect)
  }
}
