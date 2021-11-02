//
//  String+Regex.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/19.
//

import Foundation

public extension String {
    func isValidHttps() -> Bool { // https://www.naver.com
        let pattern = "(?i)https?:\\/\\/(?:www\\.)?\\S+(?:\\/|\\b)"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.count >= 1 ? true : false
        } catch _ {
            // DEBUG_LOG(error)
            return false
        }
    }
}
