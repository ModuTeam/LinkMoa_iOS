//
//  IntegratedFolder.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/06/18.
//

import Foundation

public struct IntegratedFolder: Codable {
    public let categoryIndex: Int?
    public let categoryName: String?
    public let detailCategoryIndex: Int
    public let detailCategoryName: String
    public let folderIndex: Int
    public let folderName: String
    public let folderType: String
    public let folderUpdatedAt: String?
    public let likeCount: Int
    public let likeStatus: Int
    public let linkCount: Int
    public let linkImageURL: String?
    public let updatedAt: String?
    public let userIndex: Int?
    
    enum CodingKeys: String, CodingKey {
        case categoryIndex = "categoryIdx"
        case categoryName
        case detailCategoryIndex = "detailCategoryIdx"
        case detailCategoryName
        case folderIndex = "folderIdx"
        case folderName
        case folderType
        case folderUpdatedAt
        case likeCount = "likeFolderCount"
        case likeStatus
        case linkCount = "folderLinkCount"
        case linkImageURL = "linkImageUrl"
        case updatedAt
        case userIndex = "userIdx"
    }

    public init(
        userIndex: Int,
        folderIndex: Int,
        categoryIndex: Int,
        folderName: String,
        folderType: String,
        folderUpdatedAt: String,
        likeCount: Int,
        linkCount: Int,
        linkImageURL: String,
        likeStatus: Int,
        categoryName: String,
        detailCategoryIndex: Int,
        detailCategoryName: String,
        updatedAt: String
    ) {
        self.folderIndex = folderIndex
        self.userIndex = userIndex
        self.categoryIndex = categoryIndex
        self.categoryName = categoryName
        self.detailCategoryIndex = detailCategoryIndex
        self.detailCategoryName = detailCategoryName
        self.folderName = folderName
        self.folderType = folderType
        self.folderUpdatedAt = folderUpdatedAt
        self.likeCount = likeCount
        self.linkCount = linkCount
        self.linkImageURL = linkImageURL
        self.likeStatus = likeStatus
        self.updatedAt = updatedAt
    }
    
    public init() {
        self.init(
            userIndex: 0,
            folderIndex: 0,
            categoryIndex: 0,
            folderName: "",
            folderType: "",
            folderUpdatedAt: "",
            likeCount: 0,
            linkCount: 0,
            linkImageURL: "",
            likeStatus: 0,
            categoryName: "",
            detailCategoryIndex: 0,
            detailCategoryName: "",
            updatedAt: ""
        )
    }
}

extension IntegratedFolder: Equatable {}
