//
//  StringTests.swift
//  ChatGPTTests
//
//  Created by Wenyan Zhao on 2023/5/10.
//

@testable import ChatGPT
import XCTest

final class StringTests: XCTestCase {
  func testExample() throws {
    let string: String = "model_not_found"
    
    let result = string.replaceUnderlineToWhiteSpaceAndCapitalized
    
    XCTAssertEqual(result, "Model Not Found")
  }
}
