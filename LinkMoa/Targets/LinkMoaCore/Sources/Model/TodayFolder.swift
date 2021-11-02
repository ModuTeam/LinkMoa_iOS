//
//  TodayFolder.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/23.
//

import Foundation

public struct TodayFolder: Codable {
    public let isSuccess: Bool
    public let code: Int
    public let userIndex: Int
    public let message: String
    public let result: [Result]
    
    enum CodingKeys: String, CodingKey {
        case userIndex = "userIdx"
        case isSuccess, code, message, result
    }
    
    public struct Result: Codable {
        public let index: Int
        public let name: String
        public let linkCount: Int
        public let linkImageURL: String
        
        enum CodingKeys: String, CodingKey {
            case index = "folderIdx"
            case name = "folderName"
            case linkCount = "folderLinkCount"
            case linkImageURL = "linkImageUrl"
        }
        
        public init() {
            self.init(index: 0, name: "추천 링크달", linkCount: 0, linkImageURL: "-1")
        }
        
        public init(index: Int, name: String, linkCount: Int, linkImageURL: String) {
            self.index = index
            self.name = name
            self.linkCount = linkCount
            self.linkImageURL = linkImageURL
        }
    }
}

extension TodayFolder.Result: Equatable {}
