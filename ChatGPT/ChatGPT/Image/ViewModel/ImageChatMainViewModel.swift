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
  var openAI = OpenAIServer(authAPIKey: "")
  
  init() {
    imageSet = StorageManager.restoreImageSet()
    initOpenAI(StorageManager.restoreUser().apiKeySelect)
  }
  
  func initOpenAI(_ apiKey: String) {
    openAI = OpenAIServer(authAPIKey: apiKey)
  }
  
  func sendPrompt(_ prompt: String) {
    if prompt.isEmpty {
      isShowAlert = true
      alertInfo = NSLocalizedString("Message cannot be empty", comment: "")
      return
    }
    isShowLoading = true
    openAI.sendChatImage(with: prompt, number: imageSet.number, size: imageSet.size) { result in
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
}

extension ImageChatMainViewModel {
  func isTextFieldDisable() -> Bool {
    return StorageManager.restoreUser().apiKeyList.isEmpty
  }
  
  func makePlaceholder() -> String {
    let noAPIKeyAdded = StorageManager.restoreUser().apiKeyList.isEmpty
    return noAPIKeyAdded ? "Please add APIKey on 'me'" : "Input your message"
  }
  
  func isButtonDisable() -> Bool {
    return isShowLoading || isTextFieldDisable()
  }
}
