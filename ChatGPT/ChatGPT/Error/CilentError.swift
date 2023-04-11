//
//  CilentError.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/4/11.
//

import Foundation

struct ClientError: Error {
  var type: String
  var message: String
}
