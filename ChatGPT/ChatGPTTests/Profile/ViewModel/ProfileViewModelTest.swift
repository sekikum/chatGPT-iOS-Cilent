//
//  ProfileViewModelTests.swift
//  ProfileViewModelTests
//
//  Created by Wenyan Zhao on 2023/3/14.
//

@testable import ChatGPT
import XCTest

final class ProfileViewModelTests: XCTestCase {
  var viewModel: ProfileViewModel!
  
  override func setUp() {
    super.setUp()
    viewModel = ProfileViewModel()
  }
  
  override func tearDown() {
    viewModel = nil
    super.tearDown()
  }
  
  func test_given_first_new_api_key_when_call_addAPIKey_then_append_it_to_user_apiKeyList_and_update_apiKeySelect() throws {
    viewModel.user = UserModel(apiKeyList: [], apiKeySelect: "")
    let newApiKey = "xyz789"
    
    viewModel.addAPIKey(newApiKey)
    
    XCTAssertEqual(viewModel.user.apiKeyList.count, 1)
    XCTAssertEqual(viewModel.user.apiKeyList.first, newApiKey)
    XCTAssertEqual(viewModel.user.apiKeySelect, newApiKey)
  }
  
  func test_given_new_api_key_when_call_addAPIKey_then_append_it_to_user_apiKeyList() throws {
    let existingApiKey = "abc123"
    viewModel.user = UserModel(apiKeyList: [existingApiKey], apiKeySelect: existingApiKey)
    let newApiKey = "xyz789"
    
    viewModel.addAPIKey(newApiKey)
    
    XCTAssertEqual(viewModel.user.apiKeyList.count, 2)
    XCTAssertEqual(viewModel.user.apiKeyList.last, newApiKey)
    XCTAssertEqual(viewModel.user.apiKeySelect, existingApiKey)
  }
  
  func test_given_existing_api_key_when_call_addAPIKey_then_update_user_apiKeySelect() throws {
    let existingApiKey = "abc123"
    viewModel.user = UserModel(apiKeyList: [existingApiKey], apiKeySelect: existingApiKey)
    
    viewModel.addAPIKey(existingApiKey)
    
    XCTAssertEqual(viewModel.user.apiKeySelect, existingApiKey)
  }
  
  func test_given_existing_api_key_when_call_deleteAPIKey_then_remove_it_from_user_apiKeyList_and_update_apiKeySelect() throws {
    let apiKeyToDelete = "abc123"
    let existingApiKeyList = ["abc123", "xyz789"]
    viewModel.user = UserModel(apiKeyList: existingApiKeyList, apiKeySelect: apiKeyToDelete)
    
    viewModel.deleteAPIKey(apiKeyToDelete)
    
    XCTAssertEqual(viewModel.user.apiKeyList.count, 1)
    XCTAssertFalse(viewModel.user.apiKeyList.contains(apiKeyToDelete))
    XCTAssertEqual(viewModel.user.apiKeySelect, existingApiKeyList.last)
  }
  
  func test_given_existing_api_key_when_call_deleteAPIKey_then_remove_it_from_user_apiKeyList_and_update_apiKeySelect_to_empty() throws {
    let apiKeyToDelete = "abc123"
    let existingApiKeyList = ["abc123"]
    viewModel.user = UserModel(apiKeyList: existingApiKeyList, apiKeySelect: apiKeyToDelete)
    
    viewModel.deleteAPIKey(apiKeyToDelete)
    
    XCTAssertEqual(viewModel.user.apiKeyList.count, 0)
    XCTAssertEqual(viewModel.user.apiKeySelect, "")
  }
  
  func test_given_non_existing_api_key_when_call_deleteAPIKey_then_user_apiKeyList_and_apiKeySelect_should_not_change() throws {
    let apiKeyToDelete = "invalid-api-key"
    let existingApiKeyList = ["abc123", "xyz789"]
    viewModel.user = UserModel(apiKeyList: existingApiKeyList, apiKeySelect: "abc123")
    
    viewModel.deleteAPIKey(apiKeyToDelete)
    
    XCTAssertEqual(viewModel.user.apiKeyList.count, 2)
    XCTAssertTrue(viewModel.user.apiKeyList.contains("abc123"))
    XCTAssertTrue(viewModel.user.apiKeyList.contains("xyz789"))
    XCTAssertEqual(viewModel.user.apiKeySelect, "abc123")
  }
  
  func test_given_url_string_when_call_addBaseURL_then_update_user_baseURL() throws {
    let url = "https://example.com"
    viewModel.user = UserModel(baseURL: "")
    
    viewModel.addBaseURL(url)
    
    XCTAssertEqual(viewModel.user.baseURL, url)
  }
  
  func test_given_clearBaseURL_when_call_clearBaseURL_then_update_user_baseURL_to_empty_string() throws {
    viewModel.user = UserModel(baseURL: "https://example.com")
    
    viewModel.clearBaseURL()
    
    XCTAssertEqual(viewModel.user.baseURL, "")
  }
  
  func test_given_longer_than_eight_characters_string_when_call_maskAPIKey_then_get_first_and_last_four_characters_with_asterisk() throws {
    XCTAssertEqual(ProfileViewModel().maskAPIKey("qwert23--yuiop"), "qwer****uiop")
  }
  
  func test_given_shorter_than_four_characters_string_when_call_maskAPIKey_then_get_four_asterisk() throws {
    XCTAssertEqual(ProfileViewModel().maskAPIKey("jkl"), "****")
  }
  
  func test_given_shorter_than_eight_longer_than_four_characters_string_when_call_maskAPIKey_then_get_first_and_last_few_characters_with_asterisk() throws {
    XCTAssertEqual(ProfileViewModel().maskAPIKey("jklqwer"), "j****r")
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
