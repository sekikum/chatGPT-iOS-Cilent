//
//  ImageViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/24.
//

import Foundation

class ImageViewModel: ObservableObject {
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
      case .failure(let OpenAIError.apiError(error: error)):
        DispatchQueue.main.async {
          self.isShowLoading = false
          self.isShowAlert = true
          self.alertInfo = NSLocalizedString(error.error.message, comment: "")
        }
      case .success(let success):
        DispatchQueue.main.async {
          self.imagesURL = success.data.map({ $0.url })
          self.isShowLoading = false
        }
      case .failure(.genericError):
        self.isShowLoading = false
        self.isShowAlert = true
        self.alertInfo = NSLocalizedString("Check your network", comment: "")
      }
    }
  }
}
