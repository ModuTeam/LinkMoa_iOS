//
//  CategoryDetailFolder.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/17.
//

import Foundation

public struct CategoryDetailFolder: Codable {
    public let isSuccess: Bool
    public let code: Int
    public let message: String
    public let result: Result?
    
    public struct Result: Codable {
        public let count: Int
        public let list: [IntegratedFolder]
        
        enum CodingKeys: String, CodingKey {
            case count = "folderCount"
            case list = "folderList"
        }
    }
}
