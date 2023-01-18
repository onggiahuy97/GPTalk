//
//  String+Extension.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/4/23.
//

import Foundation

extension String {
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


