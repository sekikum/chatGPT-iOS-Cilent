//
//  ImageChatMainViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/24.
//

import Foundation

class ImageChatMainViewModel: ObservableObject {
  @Published var imageSet: ImageSetModel
  @Published var imagesURL: [String] = []
  @Published var isShowAlert: Bool = false
  @Published var alertInfo: String = ""
  @Published var isShowLoading: Bool = false
  @Published var imageTextFieldDisable: Bool = false
  
  init() {
    imageSet = StorageManager.restoreImageSet()
  }
  
  func sendPrompt(_ prompt: String) {
    if prompt.isEmpty {
      isShowAlert = true
      alertInfo = NSLocalizedString("Message cannot be empty", comment: "")
      return
    }
    isShowLoading = true
    ClientManager.shared.sendChatImage(with: prompt, number: imageSet.number, size: imageSet.size) { result in
      switch(result) {
      case .failure(let failure):
        self.isShowLoading = false
        self.isShowAlert = true
        self.alertInfo = NSLocalizedString(failure.message, comment: "")
      case .success(let success):
        if let error = success.error {
          self.isShowLoading = false
          self.isShowAlert = true
          self.alertInfo = NSLocalizedString(error.code.replaceUnderlineToWhiteSpaceAndCapitalized, comment: "")
        } else {
          guard let data = success.data else {
            return
          }
          self.imagesURL = data.map({ $0.url })
          self.isShowLoading = false
        }
      }
    }
  }
  
  func setImageTextFieldDisable() {
    imageTextFieldDisable = StorageManager.restoreUser().apiKeyList.isEmpty
  }
  
  func imagePlaceholderText() -> String {
    return imageTextFieldDisable ? "Please add APIKey on 'me'" : "Input your message"
  }
  
  func sendButtonDisable() -> Bool {
    return isShowLoading || imageTextFieldDisable
  }
}
