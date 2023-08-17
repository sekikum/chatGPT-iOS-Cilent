//
//  OpenAIServerTests.swift
//  ChatGPTTests
//
//  Created by Wenyan Zhao on 2023/5/12.
//

@testable import ChatGPT
import XCTest

struct SomeRequest: Encodable {

}

final class OpenAIServerTests: XCTestCase {
  func test_given_string_start_with_data_when_extract_JSON_data_then_return_except_data() throws {
    let line = "data: {\"key\": \"value\"}"
    let expectedData = "{\"key\": \"value\"}".data(using: .utf8)
    
    let extractedData = OpenAIServer(authAPIKey: "").extractJSONData(from: line)
    
    XCTAssertEqual(extractedData, expectedData)
  }
  
  func test_given_api_key_when_prepare_request_then_return_except_request() async {
    await StorageManager.storeUser(UserModel())
    let endpoint: OpenAIEndpoint = .completions
    let requestBody: SomeRequest = SomeRequest()
    
    let request = OpenAIServer(authAPIKey: "YOUR_API_KEY").prepareRequest(endpoint, body: requestBody)

    XCTAssertEqual(request.httpMethod, "POST")
    XCTAssertEqual(request.url?.absoluteString, "https://api.openai.com/v1/completions")
    XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer YOUR_API_KEY")
    XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
    XCTAssertNotNil(request.httpBody)
  }
}
