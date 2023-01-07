//
//  Date+Extension.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/6/23.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        
        if Calendar.current.isDateInToday(self) {
            formatter.dateFormat = "hh:mm a"
        } else {
            formatter.dateFormat = "MM/dd/yy"
        }
        return formatter.string(from: self)
    }
}
