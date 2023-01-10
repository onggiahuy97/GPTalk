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
    
    enum ModelType: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case completions, edits
        
        var name: String {
            switch self {
            case .completions: return "AI Chat"
            case .edits: return "Fix Grammar"
            }
        }
    }
    
    static let limitCharacters = 200
    
    @Published var model = ModelType.completions
    
    @Published var text = "" {
        didSet {
            
        }
    }
    
    private let editModelType = EditGPTModelType.edit(.davinci)
    
    @Published var modelType = ChatGPTModelType.gpt3(.davinci) {
        didSet {
            userDefault.set(modelType.modelString, forKey: ModelSetting.modelType.rawValue)
        }
    }
    @Published var maxTokens = 500 {
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
    
    lazy var openAI: ChatGPTService = {
        ChatGPTService(token: self.token)
    }()
    
    init() {

    }
    
    func fetchChat(completion: @escaping (String) -> Void) {
        openAI.sendCompletion(with: text, model: modelType, maxTokens: maxTokens) { result in
            switch result {
            case .failure(let error):
                print(error)
                completion(error.localizedDescription)
            case .success(let openAIResult):
                completion(self.filterResult(openAIResult))
            }
        }
        
        text = ""
    }
    
    func fixGrammar(completion: @escaping (String) -> Void) {
        let instruction = ChatGPTService.fixGrammarInstruction
        openAI.sendEdits(with: instruction, input: text) { result in
            switch result {
            case .failure(let error):
                completion(error.localizedDescription)
            case .success(let openAIResult):
                completion(self.filterResult(openAIResult))
            }
        }
        text = ""
    }
    
    private func filterResult(_ openAIResult: ChatGPT) -> String {
        var text = openAIResult.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if openAIResult.choices.first?.finishReason == "length" {
            text.append("...\n\n...not enough tokens to get full answer")
        }
        if model == .edits {
            text = "Correct: ".appending(text)
        }
        return text
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
                token = value ?? self.token
            }
        }
    }
    
    // Waring: not working correctly
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
