//
//  SmartInfo.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/4/23.
//

import NaturalLanguage

struct SmartInfo: Identifiable {
    var id: String { tag.rawValue }
    var tag: NLTag
    var names: [String]
    
    var nameType: String {
        switch self.tag {
        case.personalName:
            return "Personal Names"
        case .closeQuote, .openQuote:
            return "Quotes"
        case .placeName:
            return "Place Names"
        case .organizationName:
            return "Organization Names"
        default:
            return "Unknow"
        }
    }
    
    var systemName: String {
        switch self.tag {
        case .personalName: return "person.fill"
        case .closeQuote, .openQuote: return "quote.closing"
        case .placeName: return "photo"
        case .organizationName: return "building.2"
        default:
            return ""
        }
    }
}
