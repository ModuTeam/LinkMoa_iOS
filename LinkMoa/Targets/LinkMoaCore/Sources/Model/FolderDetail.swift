//
//  FolderDetail.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/08.
//

import Foundation

import RxDataSources

// 폴더상세조회
public struct FolderDetail: Codable {
    public let isSuccess: Bool
    public let code: Int
    public let message: String
    public let result: Result?
    
    public init() {
        self.isSuccess = false
        self.code = 0
        self.message = ""
        self.result = .init()
    }
    
    public struct Result: Codable {
        public init() {
            self.init(
                userIndex: 0,
                userNickname: "",
                folderIndex: 0,
                name: "",
                type: "",
                likeCount: 0,
                linkCount: 0,
                folderUpdatedAt: "",
                likeStatus: 0,
                hashTagList: [],
                linkList: [],
                categoryIndex: 0,
                categoryName: "",
                detailCategoryIndex: 0,
                detailCategoryName: ""
            )
        }
        
        init(
            userIndex: Int,
            userNickname: String,
            folderIndex: Int,
            name: String,
            type: String,
            likeCount: Int,
            linkCount: Int,
            folderUpdatedAt: String,
            likeStatus: Int,
            hashTagList: [HashTag],
            linkList: [Link],
            categoryIndex: Int,
            categoryName: String,
            detailCategoryIndex: Int,
            detailCategoryName: String
        ) {
            self.userIndex = userIndex
            self.userNickname = userNickname
            self.folderIndex = folderIndex
            self.name = name
            self.type = type
            self.likeCount = likeCount
            self.linkCount = linkCount
            self.folderUpdatedAt = folderUpdatedAt
            self.likeStatus = likeStatus
            self.hashTagList = hashTagList
            self.linkList = linkList
            self.categoryIndex = categoryIndex
            self.categoryName = categoryName
            self.detailCategoryIndex = detailCategoryIndex
            self.detailCategoryName = detailCategoryName
        }
        
        public let userIndex: Int
        public let userNickname: String
        public let folderIndex: Int
        public let name, type: String
        public let likeCount, linkCount: Int
        public let folderUpdatedAt: String
        public let likeStatus: Int
        public let hashTagList: [HashTag]
        public let linkList: [Link]
        public let categoryIndex: Int
        public let categoryName: String
        public let detailCategoryIndex: Int?
        public let detailCategoryName: String?
        
        public var shareItem: String {
            return name + "\n\n" + linkList.map { "\($0.name)\n\($0.url)\n\n" }.joined()
        }
        
        enum CodingKeys: String, CodingKey {
            case userIndex = "userIdx"
            case userNickname = "userNickname"
            case folderIndex = "folderIdx"
            case name = "folderName"
            case type = "folderType"
            case likeCount = "folderLikeCount"
            case linkCount = "folderLinkCount"
            case categoryIndex = "categoryIdx"
            case detailCategoryIndex = "detailCategoryIdx"
            case folderUpdatedAt, likeStatus, hashTagList, linkList, categoryName, detailCategoryName
        }
    }
    
    public struct HashTag: Codable {
        public let name: String
        
        enum CodingKeys: String, CodingKey {
            case name = "tagName"
        }
    }
    
    public struct Link: Codable, Equatable, IdentifiableType {
        public typealias Identity = Int

        public let index: Int
        public let name: String
        public let url: String
        public let faviconURL: String
        public let updateDate: String
        
        public var identity: Int {
            return index
        }
        
        public init(
            index: Int,
            name: String,
            url: String,
            faviconURL: String,
            updateDate: String
        ) {
            self.index = index
            self.name = name
            self.url = url
            self.faviconURL = faviconURL
            self.updateDate = updateDate
        }
        
        public init() {
            self.init(
                index: 0,
                name: "",
                url: "",
                faviconURL: "",
                updateDate: ""
            )
        }
        
        enum CodingKeys: String, CodingKey {
            case index = "linkIdx"
            case name = "linkName"
            case url = "linkUrl"
            case faviconURL = "linkFaviconUrl"
            case updateDate = "linkUpdatedAt"
        }
        
        public func changeName(by name: String) -> Self {
            return .init(
                index: self.index,
                name: name,
                url: self.url,
                faviconURL: self.faviconURL,
                updateDate: self.updateDate
            )
        }
        
        public func changeURL(by url: String) -> Self {
            return .init(
                index: self.index,
                name: self.name,
                url: url,
                faviconURL: self.faviconURL,
                updateDate: self.updateDate
            )
        }
    }
}

