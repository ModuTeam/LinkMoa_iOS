//
//  Int+Abbreviations.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/09.
//

import Foundation

public extension Int {
    static var thousand: Int {
        return 1000
    }
    
    static var tenThousand: Int {
        return 10000
    }
    
    static var hundredMillion: Int {
        return 100000000
    }
    
    var toAbbreviationString: String {
        let number = Double(self)
        let thousand = number / Double(Int.thousand)
        let tenThousand = number / Double(Int.tenThousand)
        let hundredMillion = number / Double(Int.hundredMillion)
        
        if hundredMillion >= 1 {
            return String(format: hundredMillion >= 1.1 ? "%.1f억" : "%.0f억", hundredMillion)
        }
        
        if tenThousand >= 1 {
            return String(format: tenThousand >= 1.1 ? "%.1f만" : "%.0f만", tenThousand)
        }
        
        if thousand >= 1 {
            return String(format: thousand >= 1.1 ? "%.1f천" : "%.0f천", thousand)
        }
        
        return String(self)
    }
}
