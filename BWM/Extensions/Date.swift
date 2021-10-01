//
//  Date.swift
//  BWM
//
//  Created by Serhii on 8/26/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation

extension Date {
    
    func stringRepresentation(includeTime: Bool, extendedFormat: Bool) -> String {
        let calendar = Calendar.current
        let diffInDays = calendar.dateComponents([.day], from: calendar.startOfDay(for: self), to: calendar.startOfDay(for: Date())).day
        var dateStr = ""
        if let diff = diffInDays,
            diff <= 7 {
            if diff <= 1 {
                dateStr = diff == 1 ? "Yesterday" : "Today"
            }
            else {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE"
                dateStr = formatter.string(from: self)
            }
        }
        else {
            let formatter = DateFormatter()
            formatter.dateFormat = extendedFormat ? "EEE, MMM dd" : "MM.dd"
            dateStr = formatter.string(from: self)
        }
        
        if (includeTime) {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            dateStr = dateStr + ", " + formatter.string(from: self)
        }
        
        return dateStr
    }
}
