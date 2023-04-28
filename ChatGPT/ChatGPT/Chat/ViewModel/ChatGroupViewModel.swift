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
  let dataRespository: DataRespository

  init(respository: DataRespository = CoreDataRespository()) {
    self.dataRespository = respository
    self.chatGroups = self.dataRespository.fetchData()
    
    groupCount = self.chatGroups.count

    if groupCount == 0 {
      addGroup()
    }
  }

  func addGroup() {
    groupCount += 1
    let _ = dataRespository.saveChatGroup("Chat \(groupCount)")
    chatGroups = dataRespository.fetchData()
  }
  
  func deleteGroup(_ index: Int) {
    if index >= 0 && index < chatGroups.count {
      dataRespository.deleteGroup(chatGroups[index])
      chatGroups.remove(at: index)
    }
  }
}
