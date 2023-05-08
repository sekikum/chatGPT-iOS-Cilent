//
//  DataRepositoryMock.swift
//  ChatGPTTests
//
//  Created by Wenyan Zhao on 2023/5/8.
//

@testable import ChatGPT
import Foundation

class DataRepositoryMock: DataRepository {
  private var chatGroups: [ChatGroup] = []
  
  func fetchData() -> [ChatGroup] {
    return chatGroups
  }
  
  func saveChatGroup(_ content: String) -> ChatGroup {
    let group = ChatGroup(context: .init(concurrencyType: .mainQueueConcurrencyType), content: content)
    chatGroups.append(group)
    return group
  }
  
  func saveChatLine(_ group: ChatGroup, content: MessageModel) {
    let line = ChatLine(context: .init(concurrencyType: .mainQueueConcurrencyType), content: content)
    group.addToContains(line)
  }
  
  func savePrompt(_ group: ChatGroup, content: String) {
    group.prompt = content
  }
  
  func deleteGroup(_ group: ChatGroup) {
    if let index = chatGroups.firstIndex(of: group) {
      chatGroups.remove(at: index)
    }
  }
  
  func deleteGroupContains(_ group: ChatGPT.ChatGroup) {
    if let lines = group.contains {
      let mutableLines = lines.mutableCopy() as! NSMutableSet
      mutableLines.forEach { line in
        mutableLines.remove(line)
      }
    }
  }
}
