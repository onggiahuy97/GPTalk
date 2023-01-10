//
//  ChatGPTEndpoint.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/3/23.
//

import Foundation


enum ChatGPTEndPoint {
    case completions
    case edits
}

extension ChatGPTEndPoint {
    var path: String {
        switch self {
        case .completions:
            return "/v1/completions"
        case .edits:
            return "/v1/edits"
        }
    }
    
    var method: String {
        switch self {
        case .completions, .edits: return "POST"
        }
    }
    
    func baseURL() -> String {
        switch self {
        case .completions, .edits: return "https://api.openai.com"
        }
    }
}

