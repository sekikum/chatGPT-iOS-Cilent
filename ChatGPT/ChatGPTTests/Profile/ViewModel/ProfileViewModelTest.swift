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
  
  func test_given_normal_url_string_when_call_isValidURL_then_get_true() throws {
    XCTAssertEqual(ProfileViewModel().isValidURL("https://sekikum.cc:8080"), true)
  }
  
  func test_given_illegal_url_string_when_call_isValidURL_then_get_false() throws {
    XCTAssertEqual(ProfileViewModel().isValidURL("https://sekikum.cc:808 0"), false)
  }
  
  func test_given_normal_url_string_when_call_trimString_then_get_itself() throws {
    XCTAssertEqual(ProfileViewModel().trimString("https://sekikum.cc:8080"), "https://sekikum.cc:8080")
  }
  
  func test_given_whiteSpace_and_newline_begin_url_string_when_call_trimString_then_get_itself() throws {
    XCTAssertEqual(ProfileViewModel().trimString("  \n https://sekikum.cc:8080  "), "https://sekikum.cc:8080")
  }
}
