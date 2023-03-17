//
//  MessageViewModelTest.swift
//  ChatGPTTests
//
//  Created by Wenyan Zhao on 2023/3/16.
//

@testable import ChatGPT
import XCTest

final class MessageViewModelTests: XCTestCase {
  func test_given_string_beginning_and_ending_with_a_newline_when_call_trimMessage_then_get_no_newline_string() throws {
    XCTAssertEqual(MessageViewModel().trimMessage("\n\nqwertyuiop\n\n"), "qwertyuiop")
  }
  
  func test_given_string_beginning_with_a_newline_and_space_when_call_trimMessage_then_get_string_with_space_beginning() throws {
    XCTAssertEqual(MessageViewModel().trimMessage("\n  jkl"), "  jkl")
  }
  
  func test_given_string_with_newline_in_between_when_call_trimMessage_then_get_original_string() throws {
    XCTAssertEqual(MessageViewModel().trimMessage("jkl\nqwer"), "jkl\nqwer")
  }
}
