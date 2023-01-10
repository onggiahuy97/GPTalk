//
//  EditGPTModelType.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/9/23.
//

import Foundation

enum EditGPTModelType {
    case edit(EditGPT)
    
    var modelName: String {
        switch self {
        case .edit(let model): return model.rawValue
        }
    }
    
    enum EditGPT: String {
        case davinci = "text-davinci-edit-001"
    }
}
