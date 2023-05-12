//
//  ChatServer.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/21.
//

import Foundation
import Alamofire

public class OpenAIServer {
  fileprivate(set) var apiKey: String?
  var streamRequest: DataStreamRequest?
  
  public init(authAPIKey: String) {
    self.apiKey = authAPIKey
  }
}

extension OpenAIServer {
  func sendChat(with messages: [ChatMessage], model: String, maxTokens: Int? = nil, completionHandler: @escaping (Result<OpenAI<MessageResult>, ClientError>) -> Void) {
    let endpoint = OpenAIEndpoint.chat
    let body = ChatConversation(messages: messages, model: model, maxTokens: maxTokens)
    let request = prepareRequest(endpoint, body: body)
    
    makeStreamRequest(request: request) { response in
      switch response {
      case .success(let success):
        do {
          let string = String(decoding: success, as: UTF8.self)
          if string.hasPrefix("{\n    \"error\":") {
            let res = try JSONDecoder().decode(OpenAI<MessageResult>.self, from: success)
            completionHandler(.success(res))
          }
          let lines = string.components(separatedBy: "\n")
          for line in lines {
            if line.hasPrefix("data: [DONE]") {
              return
            }
            if line.hasPrefix("data: ") {
              let jsonString = line.replacingOccurrences(of: "data: ", with: "")
              guard let jsonData = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
                return
              }
              let res = try JSONDecoder().decode(OpenAI<MessageResult>.self, from: jsonData)
              completionHandler(.success(res))
            }
          }
        } catch {
          completionHandler(.failure(ClientError(type: "unknown_error", message: "Unknown Error")))
        }
      case .failure:
        completionHandler(.failure(ClientError(type: "network_error", message: "Check Your Network")))
      }
    }
  }
  
  private func makeStreamRequest(request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
    streamRequest = AF.streamRequest(request).responseStream { stream in
      switch stream.event {
      case let .stream(result):
        switch result {
        case let .success(data):
          completionHandler(.success(data))
        case let .failure(error):
          completionHandler(.failure(error))
        }
      case .complete:
        return
      }
    }
  }
  
  private func makeRequest(request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
    AF.request(request).response { response in
      DispatchQueue.main.async {
        if let error = response.error {
          completionHandler(.failure(error))
        } else if let data = response.data {
          completionHandler(.success(data))
        }
      }
    }
  }
  
  func sendChatImage(with prompt: String, number: Int, size: String, completionHandler: @escaping (Result<OpenAIImage<ImageResult>, ClientError>) -> Void) {
    let endpoint = OpenAIEndpoint.image
    let body = ChatImageModel(prompt: prompt, n: number, size: size)
    let request = prepareRequest(endpoint, body: body)
    
    makeRequest(request: request) { response in
      switch response {
      case .success(let success):
        do {
          let res = try JSONDecoder().decode(OpenAIImage<ImageResult>.self, from: success)
          completionHandler(.success(res))
        } catch {
          completionHandler(.failure(ClientError(type: "unknown_error", message: "Unknown Error")))
        }
      case .failure:
        completionHandler(.failure(ClientError(type: "network_error", message: "Check Your Network")))
      }
    }
  }
  
  private func prepareRequest<BodyType: Encodable>(_ endpoint: OpenAIEndpoint, body: BodyType) -> URLRequest {
    var urlComponents = URLComponents(url: URL(string: endpoint.baseURL())!, resolvingAgainstBaseURL: true)
    urlComponents?.path = endpoint.path
    var request = URLRequest(url: urlComponents!.url!)
    request.httpMethod = endpoint.method
    
    if let apiKey = self.apiKey {
      request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    }
    
    request.setValue("application/json", forHTTPHeaderField: "content-type")
    
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(body) {
      request.httpBody = encoded
    }
    
    return request
  }
  
  func updateAPIKey(_ apiKey: String) {
    self.apiKey = apiKey
  }
  
  func cancelStreamRequest() {
    streamRequest?.cancel()
  }
}
