//
//  ChatMainViewModelTest.swift
//  ChatGPTTests
//
//  Created by Wenyan Zhao on 2023/5/9.
//

@testable import ChatGPT
import XCTest

final class ChatMainViewModelTest: XCTestCase {
  var viewModel: ChatMainViewModel!
  var chatGroup: ChatGroup!
  var dataRepositoryMock: DataRepositoryMock!
  
  override func setUpWithError() throws {
    dataRepositoryMock = DataRepositoryMock()
    chatGroup = dataRepositoryMock.saveChatGroup("Test Group")
    viewModel = ChatMainViewModel(chatGroup: chatGroup, dataRepository: dataRepositoryMock)
  }
  
  func test_given_empty_message_when_call_sendMessage_then_show_except_alert() throws {
    viewModel.sendMessage("", "gpt-3.5")

    XCTAssertTrue(viewModel.isShowAlert)
    XCTAssertEqual(viewModel.alertInfo, NSLocalizedString("Message cannot be empty", comment: ""))
  }
  
  func test_given_message_role_not_nil_when_call_update_systemMessage_then_add_items_to_message_items() {
    viewModel.messageItems = [
      MessageModel(message: "1+1=?", isUser: true)
    ]
    let systemMessage = ChatMessage(role: .system, content: "2")
    
    viewModel.updateSystemMessage(systemMessage)
    
    XCTAssertEqual(viewModel.messageItems.count, 2)
    XCTAssertEqual(viewModel.messageItems.last?.message, "")
    XCTAssertEqual(viewModel.messageItems.last?.isUser, false)
  }
  
  func test_given_message_role_is_nil_when_call_update_systemMessage_then_change_last_item_message() {
    viewModel.messageItems = [
      MessageModel(message: "10+10=?", isUser: true),
      MessageModel(message: "2", isUser: false)
    ]
    let systemMessage = ChatMessage(role: nil, content: "0")
    
    viewModel.updateSystemMessage(systemMessage)
    
    XCTAssertEqual(viewModel.messageItems.count, 2)
    XCTAssertEqual(viewModel.messageItems.last?.message, "20")
    XCTAssertEqual(viewModel.messageItems.last?.isUser, false)
  }
  
  func test_given_message_role_and_message_are_nil_when_call_update_systemMessage_then_nothing_changed() {
    viewModel.messageItems = [
      MessageModel(message: "1+1=?", isUser: true),
      MessageModel(message: "2", isUser: false)
    ]
    let systemMessage = ChatMessage(role: nil, content: nil)
    
    viewModel.updateSystemMessage(systemMessage)
    
    XCTAssertEqual(viewModel.messageItems.count, 2)
    XCTAssertEqual(viewModel.messageItems.last?.message, "2")
    XCTAssertEqual(viewModel.messageItems.last?.isUser, false)
  }
  
  func test_given_message_string_when_update_user_message_then_message_items_append() {
    let messageString = "Good afternoon"
    
    viewModel.updateUserMessage(messageString)
    
    XCTAssertEqual(viewModel.messageItems.count, 1)
    XCTAssertEqual(viewModel.messageItems.first?.message, "Good afternoon")
    XCTAssertEqual(viewModel.messageItems.first?.isUser, true)
  }
  
  func test_given_empty_prompt_and_message_model_array_when_convert_to_chat_messages_then_get_chat_message_array() {
    let messageItems = [
      MessageModel(message: "1+1=?", isUser: true),
      MessageModel(message: "2", isUser: false)
    ]
    
    let chatMessages = viewModel.convertToChatMessages(from: messageItems)
    
    XCTAssertEqual(chatMessages.last?.role, .system)
    XCTAssertEqual(chatMessages.first?.content, "1+1=?")
    XCTAssertEqual(chatMessages.count, 2)
  }
  
  func test_given_prompt_and_message_model_array_when_convert_to_chat_messages_then_get_chat_message_array() {
    viewModel.prompt = "Let my message words close to native speakers"
    let messageItems = [
      MessageModel(message: "It's a nasty day", isUser: true),
      MessageModel(message: "Today's weather is quite unpleasant.", isUser: false)
    ]
    
    let chatMessages = viewModel.convertToChatMessages(from: messageItems)
    
    XCTAssertEqual(chatMessages.last?.role, .system)
    XCTAssertEqual(chatMessages.first?.role, .assistant)
    XCTAssertEqual(chatMessages.first?.content, "Let my message words close to native speakers")
    XCTAssertEqual(chatMessages.count, 3)
  }
  
  func test_given_error_message_when_set_error_data_then_get_except_data() {
    let errorMessage = NSLocalizedString("Invalid Api Key", comment: "")
    
    viewModel.setErrorData(errorMessage: errorMessage)
    
    XCTAssertFalse(viewModel.isShowLoading)
    XCTAssertTrue(viewModel.isShowAlert)
    XCTAssertFalse(viewModel.isStreamingMessage)
    XCTAssertEqual(viewModel.alertInfo, errorMessage)
  }
  
  func test_given_send_message_items_and_message_items_when_clear_context_then_get_empty_array() {
    viewModel.messageItems = [
      MessageModel(message: "1+1=?", isUser: true),
      MessageModel(message: "2", isUser: false)
    ]
    viewModel.sendMessageItems = [
      ChatMessage(role: .assistant, content: "calculate"),
      ChatMessage(role: .user, content: "1+1=?"),
      ChatMessage(role: .system, content: "2"),
    ]
    
    viewModel.clearContext()
    
    XCTAssertEqual(viewModel.messageItems.count, 0)
    XCTAssertEqual(viewModel.sendMessageItems.count, 0)
  }
  
  func test_given_empty_message_items_when_save_message_to_group_then_save_message_not_called() {
    viewModel.messageItems = []
    
    viewModel.saveMessageToGroup()
    
    XCTAssertFalse(dataRepositoryMock.isSaveMessageCalled)
  }
  
  func test_given_prompt_when_save_prompt_then_get_except_chat_group_prompt() {
    viewModel.prompt = "calculate"
    
    viewModel.savePrompt()
    
    XCTAssertEqual(viewModel.chatGroup.prompt, "calculate")
  }
  
  func test_given_is_streaming_message_true_when_cancel_streaming_then_get_true() {
    viewModel.isStreamingMessage = true
    
    viewModel.cancelStreaming()
    
    XCTAssertFalse(viewModel.isStreamingMessage)
  }
  
  func test_given_nil_group_title_when_get_group_title_then_get_unkown() {
    viewModel.chatGroup.title = nil
    
    XCTAssertEqual("unkown", viewModel.getGroupTitle())
  }
}
