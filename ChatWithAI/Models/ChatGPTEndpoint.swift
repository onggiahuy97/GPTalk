//
//  ChatGPTEndpoint.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/3/23.
//

import Foundation


enum ChatGPTEndPoint {
    case compltions
}

extension ChatGPTEndPoint {
    var path: String {
        switch self {
        case .compltions:
            return "/v1/completions"
        }
    }
    
    var method: String {
        switch self {
        case .compltions: return "POST"
        }
    }
    
    func baseURL() -> String {
        switch self {
        case .compltions: return "https://api.openai.com"
        }
    }
}

