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
  
  func makePlaceholder() -> String {
    return getTextFieldDisable() ? "Please add APIKey on 'me'" : "Input your message"
  }
  
  func makeButtonImage() -> String {
    isStreaming ? "stop.circle.fill" : "paperplane.circle.fill"
  }
  
  func updateButtonAction(send: () -> Void) {
    if isStreaming {
      cancel()
    } else {
      send()
    }
  }
  
  func isButtonDisable() -> Bool {
    return isShowLoading || getTextFieldDisable()
  }
  
  func getTextFieldDisable() -> Bool {
    return StorageManager.restoreUser().apiKeyList.isEmpty
  }
}
