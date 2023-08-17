//
//  ImageChatMainViewModelTests.swift
//  ChatGPTTests
//
//  Created by Wenyan Zhao on 2023/5/15.
//

@testable import ChatGPT
import XCTest

final class ImageChatMainViewModelTests: XCTestCase {
  var viewModel: ImageChatMainViewModel!
  
  override func setUpWithError() throws {
    viewModel = ImageChatMainViewModel()
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func test_given_empty_prompt_when_send_prompt_then_show_alert() throws {
    viewModel.sendPrompt("")
    
    XCTAssertTrue(viewModel.isShowAlert)
    XCTAssertEqual(viewModel.alertInfo, NSLocalizedString("Message cannot be empty", comment: ""))
  }
  
  func test_given_empty_api_key_list_when_set_image_text_field_disable() {
    viewModel.setImageTextFieldDisable()
    
    XCTAssertTrue(viewModel.imageTextFieldDisable)
  }
}
