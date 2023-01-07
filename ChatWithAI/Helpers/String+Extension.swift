//
//  String+Extension.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/4/23.
//

import NaturalLanguage
import Foundation

extension String {
    func getRangeOfPersonName() -> [SmartInfo] {
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = self

        let options: NLTagger.Options = [.joinNames]
        let tags: [NLTag] = [.personalName, .placeName, .organizationName]

        var dict = [NLTag: [String]]()

        tagger.enumerateTags(in: self.startIndex..<self.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
            if let tag = tag, tags.contains(tag) {
                let name = "\(self[tokenRange])"
                if let names = dict[tag], !names.contains(where: { $0 == name }) {
                    dict[tag] = names + [name]
                } else {
                    dict[tag] = [name]
                }
            }
                
           return true
        }
        
        return dict.map { SmartInfo(tag: $0.key, names: $0.value)}
    }
    
    func makeGoogleURL() -> URL? {
        let text = self.filter { !$0.isPunctuation }
        let searchTerm = text.replacingOccurrences(of: " ", with: "+")
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.google.com"
        components.path = "/search"
        components.queryItems = [URLQueryItem(name: "q", value: searchTerm)]
        let queryURl = components.url
        return queryURl
    }
}


