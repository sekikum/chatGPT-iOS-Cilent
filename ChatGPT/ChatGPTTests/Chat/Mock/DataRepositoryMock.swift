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
  public var isSaveMessageCalled = false
  
  func fetchData() -> [ChatGroup] {
    return chatGroups
  }
  
  func saveChatGroup(_ content: String) -> ChatGroup {
    let group = ChatGroup(context: .init(concurrencyType: .mainQueueConcurrencyType), content: content)
    chatGroups.append(group)
    return group
  }
  
  func saveMessage(_ group: ChatGroup, content: MessageModel) {
    let message = Message(context: .init(concurrencyType: .mainQueueConcurrencyType), content: content)
    group.addToContains(message)
    
    isSaveMessageCalled = true
  }
  
  func savePrompt(_ group: ChatGroup, content: String) {
    group.prompt = content
  }
  
  func deleteChatGroup(_ group: ChatGroup) {
    if let index = chatGroups.firstIndex(of: group) {
      chatGroups.remove(at: index)
    }
  }
  
  func clearChatGroupContext(_ group: ChatGPT.ChatGroup) {
    if let messages = group.contains {
      let mutableMessages = messages.mutableCopy() as! NSMutableSet
      mutableMessages.forEach { message in
        mutableMessages.remove(message)
      }
    }
  }
}
