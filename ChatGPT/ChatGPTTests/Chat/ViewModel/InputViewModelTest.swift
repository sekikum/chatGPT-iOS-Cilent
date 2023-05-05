//
//  InputViewModelTest.swift
//  ChatGPTTests
//
//  Created by Wenyan Zhao on 2023/5/5.
//

@testable import ChatGPT
import XCTest
import SwiftUI

final class InputViewModelTest: XCTestCase {
  override func setUp() {
    super.setUp()
    StorageManager.defaultStand.removeObject(forKey: StorageManager.USER_KEY)
  }
  
  override func tearDown() {
    super.tearDown()
    StorageManager.defaultStand.removeObject(forKey: StorageManager.USER_KEY)
  }
  
  func test_given_no_api_key_when_make_placeholder_then_return_expected_placeholder() {
    let viewModel = InputViewModel(
      isStreaming: false,
      isShowLoading: false,
      send: { _, _ in },
      cancel: {}
    )
    let expectedPlaceholder = "Please add APIKey on 'me'"

    XCTAssertEqual(viewModel.makePlaceholder(), expectedPlaceholder)
  }
  
  func test_given_api_key_when_make_placeholder_then_return_expected_placeholder() async {
    let user = UserModel(apiKeyList: ["abc123"])
    await StorageManager.storeUser(user)
    let viewModel = InputViewModel(
      isStreaming: false,
      isShowLoading: false,
      send: { _, _ in },
      cancel: {}
    )
    let expectedPlaceholder = "Input your message"

    XCTAssertEqual(viewModel.makePlaceholder(), expectedPlaceholder)
  }
  
  func test_given_streaming_state_when_make_button_image_then_return_expected_image_name() {
    let viewModel = InputViewModel(
      isStreaming: true,
      isShowLoading: false,
      send: { _, _ in },
      cancel: {}
    )
    let expectedImageName = "stop.circle.fill"
    
    XCTAssertEqual(viewModel.makeButtonImage(), expectedImageName)
  }
  
  func test_given_not_streaming_state_when_make_button_image_then_return_expected_image_name() {
    let viewModel = InputViewModel(
      isStreaming: false,
      isShowLoading: false,
      send: { _, _ in },
      cancel: {}
    )
    let expectedImageName = "paperplane.circle.fill"
    
    XCTAssertEqual(viewModel.makeButtonImage(), expectedImageName)
  }
  
  func test_given_not_is_streaming_when_update_button_action_then_call_send() {
    var isSendCalled = false
    var isCancelCalled = false
    let viewModel = InputViewModel(
      isStreaming: false,
      isShowLoading: false,
      send: { _, _ in},
      cancel: {
        isCancelCalled = true
      }
    )
    
    viewModel.updateButtonAction(send: {
      isSendCalled = true
    })
    
    XCTAssertTrue(isSendCalled)
    XCTAssertFalse(isCancelCalled)
  }
  
  func test_given_not_streaming_state_when_update_button_action_then_toggle_streaming_state() {
    var isSendCalled = false
    var isCancelCalled = false
    let viewModel = InputViewModel(
      isStreaming: true,
      isShowLoading: false,
      send: { _, _ in},
      cancel: {
        isCancelCalled = true
      }
    )
    
    viewModel.updateButtonAction(send: {
      isSendCalled = true
    })
    
    XCTAssertFalse(isSendCalled)
    XCTAssertTrue(isCancelCalled)
  }
  
  func test_given_not_loading_and_not_text_field_disabled_state_when_is_button_disabled_then_return_false() {
    let viewModel = InputViewModel(
      isStreaming: false,
      isShowLoading: false,
      send: { _, _ in },
      cancel: {}
    )
    XCTAssertTrue(viewModel.isButtonDisable())
  }
  
  func test_given_loading_state_when_is_button_disabled_then_return_true() {
    let viewModel = InputViewModel(
      isStreaming: false,
      isShowLoading: true,
      send: { _, _ in },
      cancel: {}
    )
    
    XCTAssertTrue(viewModel.isButtonDisable())
  }
  
  func test_given_text_field_disabled_state_when_is_button_disabled_then_return_true() async {
    let user = UserModel(apiKeyList: ["abc123"])
    await StorageManager.storeUser(user)
    let viewModel = InputViewModel(
      isStreaming: false,
      isShowLoading: false,
      send: { _, _ in },
      cancel: {}
    )
    XCTAssertFalse(viewModel.isButtonDisable())
  }
}
