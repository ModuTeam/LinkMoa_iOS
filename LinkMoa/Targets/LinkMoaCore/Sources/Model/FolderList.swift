//
//  FolderList.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/08.
//

import Foundation
import RxDataSources

/// 폴더조회(나의 가리비)
public struct FolderList: Codable {
    public let isSuccess: Bool
    public let code: Int
    public let message: String
    public let result: [Result]?
    
    public struct Result: Codable, Equatable, IdentifiableType {
        public typealias Identity = Int
        
        public let index: Int
        public let name: String
        public let linkCount: Int
        public let folderType: String
        public let imageURL: String
        public let updateDate: String
        
        public var identity: Int {
            return index
        }
        
        enum CodingKeys: String, CodingKey {
            case index = "folderIdx"
            case name = "folderName"
            case linkCount = "folderLinkCount"
            case imageURL = "linkImageUrl"
            case updateDate = "updatedAt"
            case folderType
        }
    }
}
