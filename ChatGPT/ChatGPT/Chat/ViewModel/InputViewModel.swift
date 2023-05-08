//
//  InputViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/4/25.
//

import SwiftUI

struct InputViewModel {
  let isStreaming: Bool
  let isShowLoading: Bool
  let send: (String, String) -> Void
  let cancel: () -> Void
  
  func messagePlaceholderText() -> String {
    return messageTextFieldDisable() ? "Please add APIKey on 'me'" : "Input your message"
  }
  
  func sendButtonImage() -> String {
    isStreaming ? "stop.circle.fill" : "paperplane.circle.fill"
  }
  
  func updateSendButtonAction(send: () -> Void) {
    if isStreaming {
      cancel()
    } else {
      send()
    }
  }
  
  func sendButtonDisable() -> Bool {
    return isShowLoading || messageTextFieldDisable()
  }
  
  func messageTextFieldDisable() -> Bool {
    return StorageManager.restoreUser().apiKeyList.isEmpty
  }
}
