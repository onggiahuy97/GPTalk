//
//  ChatGPTModelType.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/3/23.
//

import Foundation

enum ChatGPTModelType: Hashable {
    case gpt3(GPT3)
    
    var modelString: String {
        switch self {
        case .gpt3(let model): return model.rawValue
        }
    }
    
    #warning("Beta testing")
    var maxTokens: String {
        switch self {
        case .gpt3(.davinci):
            return "500"
        default:
            return "1000"
        }
    }
    
    var goodAt: String {
        switch self {
        case .gpt3(.davinci):
            return "Complex intent, cause and effect, summarization for audience"
        case .gpt3(.curie):
            return "Language translation, complex classification, text sentiment, summarization"
        case .gpt3(.baddage):
            return "Moderate classification, semantic search classification"
        case .gpt3(.ada):
            return "Parsing text, simple classification, address correction, keywords"
        }
    }
    
    var description: String {
        switch self {
        case .gpt3(.davinci):
           return "The most powerful GPT-3 model. Does all tasks that the other models are capable of performing, frequently with higher quality, longer output, and better instruction-following. Additionally supports text completions being inserted."
        case .gpt3(.baddage):
            return "Capable of straightforward tasks, very fast, and lower cost."
        case .gpt3(.curie):
            return "Very capable, but faster and lower cost than Davinci."
        case .gpt3(.ada):
            return "Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost."
        }
    }
    
    var trainingData: String {
        switch self {
        case .gpt3(.davinci):
            return "Up to Jun 2021"
        default:
            return "Up to Oct 2019"
        }
    }
    
    enum GPT3: String, CaseIterable, Identifiable {
        var id: String { rawValue }
        case davinci = "text-davinci-003"
        case curie = "text-curie-001"
        case baddage = "text-baddage-001"
        case ada = "text-ada-001"
        
        var name: String {
            switch self {
            case .davinci: return "Davinci"
            case .curie: return "Curie"
            case .baddage: return "Baddage"
            case .ada: return "Ada"
            }
        }
    }
}
