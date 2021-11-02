//
//  SearchLink.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/11.
//

import Foundation

public struct SearchLink: Codable {
    public let isSuccess: Bool
    public let code, userIdx: Int
    public let message: String
    public let resultCount: Int
    public let result: [Result]?
    
    public struct Result: Codable {
        public let linkIndex, folderIndex, userIndex: Int
        public let name: String
        public let url: String
        public let imageURL: String
        public let faviconURL: String
        public let folderUpdatedAt: String
        
        enum CodingKeys: String, CodingKey {
            case linkIndex = "linkIdx"
            case folderIndex = "folderIdx"
            case userIndex = "userIdx"
            case name = "linkName"
            case url = "linkUrl"
            case imageURL = "linkImageUrl"
            case faviconURL = "linkFaviconUrl"
            case folderUpdatedAt
        }
    }
}

extension SearchLink.Result: Equatable {}
