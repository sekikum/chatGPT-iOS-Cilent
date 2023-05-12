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
  public var isSavePromptCalled = false
  
  func fetchData() -> [ChatGroup] {
    return chatGroups
  }
  
  func saveChatGroup(_ content: String) -> ChatGroup {
    let group = ChatGroup(context: .init(concurrencyType: .mainQueueConcurrencyType), content: content)
    chatGroups.append(group)
    return group
  }
  
  func saveMessage(_ group: ChatGroup, content: MessageModel) {
    isSaveMessageCalled = true
  }
  
  func savePrompt(_ group: ChatGroup, content: String) {
    isSavePromptCalled = true
  }
  
  func deleteChatGroup(_ group: ChatGroup) {
    
  }
  
  func clearChatGroupContext(_ group: ChatGPT.ChatGroup) {
    
  }
}
