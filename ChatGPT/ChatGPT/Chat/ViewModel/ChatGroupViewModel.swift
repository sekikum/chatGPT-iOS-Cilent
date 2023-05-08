//
//  ChatGroupViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/4/26.
//

import Foundation
import SwiftUI

class ChatGroupViewModel: ObservableObject {
  @Published var chatGroups: [ChatGroup] = []
  var chatGroupCount: Int = 0
  let dataRepository: DataRepository = CoreDataRepository()

  func addChatGroup() {
    chatGroupCount += 1
    let _ = dataRepository.saveChatGroup("Chat \(chatGroupCount)")
    chatGroups = dataRepository.fetchData()
  }
  
  func deleteChatGroup(_ index: Int) {
    if index >= 0 && index < chatGroups.count {
      dataRepository.deleteGroup(chatGroups[index])
      chatGroups.remove(at: index)
    }
  }
  
  func setChatGroups() {
    self.chatGroups = self.dataRepository.fetchData()
    
    chatGroupCount = self.chatGroups.count

    if chatGroupCount == 0 {
      addChatGroup()
    }
  }
}
