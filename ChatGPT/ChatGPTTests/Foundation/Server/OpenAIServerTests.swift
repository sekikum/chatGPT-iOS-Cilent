//
//  OpenAIServerTests.swift
//  ChatGPTTests
//
//  Created by Wenyan Zhao on 2023/5/12.
//

@testable import ChatGPT
import XCTest

final class OpenAIServerTests: XCTestCase {
  func test_given_string_start_with_data_when_extract_JSON_data_then_return_except_data() throws {
    let line = "data: {\"key\": \"value\"}"
    let expectedData = "{\"key\": \"value\"}".data(using: .utf8)
    
    let extractedData = OpenAIServer(authAPIKey: "").extractJSONData(from: line)
    
    XCTAssertEqual(extractedData, expectedData)
  }
}
