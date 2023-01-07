//
//  ChatViewModel.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/2/23.
//

import Foundation

class ChatViewModel: ObservableObject {
    
    enum ModelSetting: String, CaseIterable {
        case modelType
        case maxTokens
        case token
    }
    
    @Published var text = ""
    
    @Published var modelType = ChatGPTModelType.gpt3(.davinci) {
        didSet {
            userDefault.set(modelType.modelString, forKey: ModelSetting.modelType.rawValue)
        }
    }
    @Published var maxTokens = 50 {
        didSet {
            userDefault.set(maxTokens, forKey: ModelSetting.maxTokens.rawValue)
        }
    }
    @Published var token = "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" {
        didSet {
            userDefault.set(token, forKey: ModelSetting.token.rawValue)
        }
    }
    
    private let userDefault = UserDefaults.standard
    
    init() {
        fetchCurrentSetting()
    }
    
    func fetchChat(completion: @escaping (String) -> Void) {
        let openAI = ChatGPTService(token: token)
        
        openAI.sendCompletion(with: text, model: modelType, maxTokens: maxTokens) { result in
            switch result {
            case .failure(let error):
                completion(error.localizedDescription)
            case .success(let openAIResult):
                var text = openAIResult.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                if openAIResult.choices.first?.finishReason == "length" {
                    text.append("...\n\n...not enough tokens to get full answer")
                }
                completion(text)
            }
        }
        
        text = ""
    }
    
    func fetchCurrentSetting() {
        ModelSetting.allCases.forEach { type in
            switch type {
            case .maxTokens:
                maxTokens = userDefault.integer(forKey: type.rawValue)
            case .modelType:
                let value = userDefault.string(forKey: type.rawValue)
                modelType = ChatGPTModelType.gpt3(.init(rawValue: value ?? "") ?? .davinci)
            case .token:
                let value = userDefault.string(forKey: type.rawValue)
                token = value ?? ""
            }
        }
    }
    
    func updateCurrentSetting() {
        ModelSetting.allCases.forEach { type in
            switch type {
            case .maxTokens:
                userDefault.set(maxTokens, forKey: type.rawValue)
            case .modelType:
                userDefault.set(modelType.modelString, forKey: type.rawValue)
            case .token:
                userDefault.set(token, forKey: type.rawValue)
            }
        }
    }
}
