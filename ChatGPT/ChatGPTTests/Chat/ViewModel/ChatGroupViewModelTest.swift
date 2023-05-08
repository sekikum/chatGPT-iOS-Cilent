//
//  ChatGroupViewModelTest.swift
//  ChatGPTTests
//
//  Created by Wenyan Zhao on 2023/5/8.
//

@testable import ChatGPT
import XCTest

final class ChatGroupViewModelTest: XCTestCase {
  
  var viewModel: ChatGroupViewModel!
  var dataRepository: DataRepository = DataRepositoryMock()
  
  override func setUpWithError() throws {
    viewModel = ChatGroupViewModel(repository: dataRepository)
  }
  
  override func tearDownWithError() throws {
    viewModel = nil
  }
  
  func test_given_chat_group_view_model_when_add_group_then_chat_group_count_increases() throws {
    XCTAssertEqual(viewModel.chatGroups.count, 1)
    viewModel.addChatGroup()
    XCTAssertEqual(viewModel.chatGroups.count, 2)
  }
  
  func test_given_chat_group_view_model_with_two_groups_when_delete_first_group_then_chat_group_count_decreases() throws {
    viewModel.addChatGroup()
    XCTAssertEqual(viewModel.chatGroups.count, 2)
    viewModel.deleteChatGroup(0)
    XCTAssertEqual(viewModel.chatGroups.count, 1)
  }

  func test_given_chat_group_view_model_when_initialized_then_chat_group_count_is_one() throws {
    XCTAssertEqual(viewModel.groupCount, 1)
    viewModel.addChatGroup()
    XCTAssertEqual(viewModel.groupCount, 2)
    viewModel.addChatGroup()
    XCTAssertEqual(viewModel.groupCount, 3)
  }
}
