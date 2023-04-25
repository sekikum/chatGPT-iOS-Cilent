//
//  InputViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/4/25.
//

import SwiftUI

struct InputViewModel {
  @Binding var isStreaming: Bool
  let isShowLoading: Bool
  let send: (String, String) -> Void
  let isTextFieldDisable = StorageManager.restoreUser().apiKeyList.isEmpty
  
  func makePlaceholder() -> String {
    return isTextFieldDisable ? "Please add APIKey on 'me'" : "Input your message"
  }
  
  func makeButtonImage() -> String {
    isStreaming ? "stop.circle.fill" : "paperplane.circle.fill"
  }
  
  func updateButtonAction(send: () -> Void) {
    if isStreaming {
      isStreaming = false
    } else {
      send()
    }
  }
  
  func isButtonDisable() -> Bool {
    return isShowLoading || isTextFieldDisable
  }
}
