//
//  ChatGPTTests.swift
//  ChatGPTTests
//
//  Created by Wenyan Zhao on 2023/3/14.
//

@testable import ChatGPT
import XCTest

final class ProfileViewModelTests: XCTestCase {
  func test_given_longer_than_eight_characters_string_when_call_maskToken_then_get_first_and_last_four_characters_with_asterisk() throws {
    XCTAssertEqual(ProfileViewModel().maskToken("qwertyuiop"), "qwer****uiop")
  }
  
  func test_given_shorter_than_four_characters_string_when_call_maskToken_then_get_four_asterisk() throws {
    XCTAssertEqual(ProfileViewModel().maskToken("jkl"), "****")
  }
  
  func test_given_shorter_than_eight_longer_than_four_characters_string_when_call_maskToken_then_get_first_and_last_few_characters_with_asterisk() throws {
    XCTAssertEqual(ProfileViewModel().maskToken("jklqwer"), "j****r")
  }
}
