//
//  String.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/4/11.
//

import Foundation

extension String {
  var formatErrorCode: String {
    return self.replacingOccurrences(of: "_", with: " ").capitalized
  }
}
