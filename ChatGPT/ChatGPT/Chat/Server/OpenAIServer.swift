//
//  ChatServer.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/21.
//

import Foundation
import Alamofire

public enum OpenAIError: Error {
  case genericError(error: Error)
  case decodingError(error: Error)
}

public class OpenAIServer {
  fileprivate(set) var apiKey: String?
  
  public init(authAPIKey: String) {
    self.apiKey = authAPIKey
  }
}

extension OpenAIServer {
  func sendChat(with messages: [ChatMessage], model: OpenAIModel, maxTokens: Int? = nil, completionHandler: @escaping (Result<OpenAI<MessageResult>, OpenAIError>) -> Void) {
    let endpoint = OpenAIEndpoint.chat
    let body = ChatConversation(messages: messages, model: model.modelName, maxTokens: maxTokens)
    let request = prepareRequest(endpoint, body: body)
    
    makeRequest(request: request) { response in
      switch response {
      case .success(let success):
        do {
          let res = try JSONDecoder().decode(OpenAI<MessageResult>.self, from: success)
          completionHandler(.success(res))
        } catch {
          completionHandler(.failure(.decodingError(error: error)))
        }
      case .failure(let failure):
        completionHandler(.failure(.genericError(error: failure)))
      }
    }
  }
  
  private func makeRequest(request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
    AF.request(request).response { response in
      if let error = response.error {
        completionHandler(.failure(error))
      } else if let data = response.data {
        completionHandler(.success(data))
      }
    }
  }
  
  func sendChatImage(with prompt: String, number: Int, size: String, completionHandler: @escaping (Result<OpenAIImage<ImageResult>, OpenAIError>) -> Void) {
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
          completionHandler(.failure(.decodingError(error: error)))
        }
      case .failure(let failure):
        completionHandler(.failure(.genericError(error: failure)))
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
}
