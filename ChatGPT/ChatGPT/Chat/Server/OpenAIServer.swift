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
          do {
            var error = try JSONDecoder().decode(OpenAIError.self, from: success)
            error.error.message = self.formatErrorMessage(error.error.message)
            completionHandler(.failure(error))
          } catch {
            print("\(error)")
          }
        }
      case .failure(let failure):
        print(failure)
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
          do {
            var error = try JSONDecoder().decode(OpenAIError.self, from: success)
            error.error.message = self.formatErrorMessage(error.error.message)
            completionHandler(.failure(error))
          } catch {
            print("\(error)")
          }
        }
      case .failure(let failure):
        print(failure)
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
  
  func formatErrorMessage(_ message: String) -> String {
    let APIKeyErrorPattern = "(?<=provided)[:\\s\\w-]+(?=\\.)"
    let ModelErrorPattern = "The model:\\s*`gpt-[.\\d-]+`\\s*"
    let regex = try! NSRegularExpression(pattern: APIKeyErrorPattern, options: [])
    var formattedMessage = regex.stringByReplacingMatches(in: message, options: [], range: NSRange(location: 0, length: message.utf16.count), withTemplate: "")
    formattedMessage = formattedMessage.replacingOccurrences(
        of: ModelErrorPattern,
        with: "The model you selected ",
        options: .regularExpression
    )
    return formattedMessage
  }
}
