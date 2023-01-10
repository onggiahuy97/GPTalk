//
//  ChatGPTInstruction.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/9/23.
//

import Foundation

class EditGPTInstruction: Encodable {
    var instruction: String
    var model: String
    var input: String
    
    init(instruction: String, model: String, input: String) {
        self.instruction = instruction
        self.model = model
        self.input = input
    }
    
    enum CodingKeys: String, CodingKey {
        case instruction
        case model
        case input
    }
}
