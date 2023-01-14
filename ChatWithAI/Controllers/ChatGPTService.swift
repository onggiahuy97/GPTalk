//
//  ChatGPTService.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/3/23.
//

import Foundation

enum ChatGPTError: Error {
    case generic(error: Error)
    case decoding(error: Error)
}

class ChatGPTService {
    fileprivate(set) var token: String?
    
    init(token: String? = nil) {
        self.token = token
    }
}

extension ChatGPTService {
    static let fixGrammarInstruction = "Fix grammar mistakes of the input"
    static let paraphraseTextInstruction = "Paraphrase the input"
    static let generalError = "Something went wrong. Try again"
    
    func sendCompletion(with prompt: String, model: ChatGPTModelType = .gpt3(.davinci), maxTokens: Int = 16, completion: @escaping (Result<ChatGPT, ChatGPTError>) -> Void) {
        let endpoint = ChatGPTEndPoint.completions
        let body = ChatGPTCommand(prompt: prompt, model: model.modelString, maxTokens: maxTokens)
        let request = makeURLRequest(endpoint: endpoint, body: body)
        
        makeRequest(request: request) { result in
            switch result {
            case .success(let success):
                do {
                    let res = try JSONDecoder().decode(ChatGPT.self, from: success)
                    completion(.success(res))
                } catch {
                    completion(.failure(.decoding(error: error)))
                }
            case .failure(let failure):
                completion(.failure(.generic(error: failure)))
            }
        }
    }
    
    func sendEdits(with instruction: String, model: EditGPTModelType = .edit(.davinci), input: String, completion: @escaping (Result<ChatGPT, ChatGPTError>) -> Void) {
        let endpoint = ChatGPTEndPoint.edits
        let body = EditGPTInstruction(instruction: instruction, model: model.modelName, input: input)
        let request = makeURLRequest(endpoint: endpoint, body: body)
        
        makeRequest(request: request) { result in
            switch result {
            case .failure(let failure):
                completion(.failure(.generic(error: failure)))
            case .success(let success):
                do {
                    let res = try JSONDecoder().decode(ChatGPT.self, from: success)
                    completion(.success(res))
                } catch {
                    completion(.failure(.decoding(error: error)))
                }
            }
        }
    }
    
    private func makeRequest(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, res, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } 
        }
        task.resume()
    }
    
    private func makeURLRequest<BodyType: Encodable>(endpoint: ChatGPTEndPoint, body: BodyType) -> URLRequest {
        var urlComponents = URLComponents(url: URL(string: endpoint.baseURL())!, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpoint.path
        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = endpoint.method
        
        if let token = self.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(body) {
            request.httpBody = encoded
        }
        
        return request
    }
}
