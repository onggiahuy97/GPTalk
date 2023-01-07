import UIKit

let openAI = ChatGPTService(token: "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")

openAI.sendCompletion(with: "Hello", model: .gpt3(.davinci), maxTokens: 50) { result in
    switch result {
    case .failure(let error):
        print(error.localizedDescription)
    case .success(let openAIResult):
        var text = openAIResult.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if openAIResult.choices.first?.finishReason == "length" {
            text.append("...")
        }
        print(text)
    }
}
