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
        case completions, edits, pharaphrase
        
        var name: String {
            switch self {
            case .completions: return "Chat"
            case .edits: return "Fix Grammar"
            case .pharaphrase: return "Paraphrase"
            }
        }
        
        var imageName: String {
            switch self {
            case .completions: return "ellipsis.bubble"
            case .edits: return "checkmark.seal"
            case .pharaphrase: return "pencil.and.outline"
            }
        }
    }
    
    static let limitCharacters = 250
    static let limitToken = 250
    
    private let editModelType = EditGPTModelType.edit(.davinci)
    private let userDefault = UserDefaults.standard

    @Published var model = ModelType.completions
    @Published var text = ""
    @Published var modelType = ChatGPTModelType.gpt3(.davinci) {
        didSet {
            userDefault.set(modelType.modelString, forKey: ModelSetting.modelType.rawValue)
        }
    }
    @Published var maxTokens = limitToken {
        didSet {
            userDefault.set(maxTokens, forKey: ModelSetting.maxTokens.rawValue)
        }
    }
    @Published var token = "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" {
        didSet {
            userDefault.set(token, forKey: ModelSetting.token.rawValue)
        }
    }
    
    lazy var openAI: ChatGPTService = {
        ChatGPTService(token: self.token)
    }()
    
    init() {}
    
    func fetchChat(completion: @escaping (String) -> Void) {
        openAI.sendCompletion(with: text, model: modelType, maxTokens: maxTokens) { result in
            switch result {
            case .failure(let error):
                print(error)
//                completion(error.localizedDescription)
                let errorText = "Something went wrong. Try again"
                completion(errorText)
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
    
    func paraphraseText(completion: @escaping (String) -> Void) {
        let instruction = ChatGPTService.paraphraseTextInstruction
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
            text = "Correct - ".appending(text)
        } else if model == .pharaphrase {
            text = "Paraphrased - ".appending(text)
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