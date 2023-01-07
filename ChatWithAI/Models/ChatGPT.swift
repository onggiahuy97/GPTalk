//
//  ChatGPT.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/3/23.
//

import Foundation

struct ChatGPT: Codable, Identifiable {
    let id: String
//    let object: String
//    let created: Int
//    let model: String
    let choices: [ChatGPTChoice]
    let usage: ChatUsage
}

struct ChatGPTChoice: Codable {
    let text: String
    let finishReason: String
    
    private enum CodingKeys: String, CodingKey {
        case text
        case finishReason = "finish_reason"
    }
}

struct ChatUsage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    private enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}
