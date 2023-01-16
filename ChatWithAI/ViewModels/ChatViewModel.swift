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
        case completions, fixGrammar, pharaphrase
        
        var name: String {
            switch self {
            case .completions: return "Chat"
            case .fixGrammar: return "Fix Grammar"
            case .pharaphrase: return "Paraphrase"
            }
        }
        
        var imageName: String {
            switch self {
            case .completions: return "ellipsis.bubble"
            case .fixGrammar: return "checkmark.seal"
            case .pharaphrase: return "pencil.and.outline"
            }
        }
        
        var instruction: String {
            switch self {
            case .completions: return ""
            case .pharaphrase : return ChatGPTService.paraphraseTextInstruction
            case .fixGrammar: return ChatGPTService.fixGrammarInstruction
            }
        }
    }
    
    static let limitCharacters = 400
    static let limitToken = 300
    static let defaultTokenKey = "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"
    
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
    @Published var token = defaultTokenKey {
        didSet {
            userDefault.set(token, forKey: ModelSetting.token.rawValue)
        }
    }
    
    lazy var openAI: ChatGPTService = {
        ChatGPTService(token: self.token)
    }()
    
    init() {
        fetchCurrentSetting()
    }
    
    func fetchChat(completion: @escaping (String) -> Void) {
        openAI.sendCompletion(with: text, model: modelType, maxTokens: maxTokens) { result in
            switch result {
            case .failure(let error):
                print(error)
                let errorText = ChatGPTService.generalError
                completion(errorText)
            case .success(let openAIResult):
                completion(self.filterResult(openAIResult))
            }
        }
        
        text = ""
    }
    
    func fetchEdits(completion: @escaping (String) -> Void) {
        openAI.sendEdits(with: model.instruction, input: text) { result in
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
        if model == .fixGrammar {
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
                let value = userDefault.integer(forKey: type.rawValue)
                maxTokens = value == 0 ? Self.limitToken : value
            case .modelType:
                let value = userDefault.string(forKey: type.rawValue)
                modelType = ChatGPTModelType.gpt3(.init(rawValue: value ?? "") ?? .davinci)
            case .token:
                let value = userDefault.string(forKey: type.rawValue)
                token = value ?? Self.defaultTokenKey
            }
        }
    }
}
