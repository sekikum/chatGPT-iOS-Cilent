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
  var groupCount: Int = 0
  let dataRepository: DataRepository = CoreDataRepository()

  func addGroup() {
    groupCount += 1
    let _ = dataRepository.saveChatGroup("Chat \(groupCount)")
    chatGroups = dataRepository.fetchData()
  }
  
  func deleteGroup(_ index: Int) {
    if index >= 0 && index < chatGroups.count {
      dataRepository.deleteGroup(chatGroups[index])
      chatGroups.remove(at: index)
    }
  }
  
  func setChatGroups() {
    self.chatGroups = self.dataRepository.fetchData()
    
    groupCount = self.chatGroups.count

    if groupCount == 0 {
      addGroup()
    }
  }
}
