//
//  CategoryInfo.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/17.
//

import Foundation

public struct CategoryInfo: Codable {
    public let isSuccess: Bool
    public let code: Int
    public let message: String
    public let result: [Result]?
    
    public struct Result: Codable {
        public let index: Int
        public let name: String
        public let detailList: [DetailCategoryList]
        
        enum CodingKeys: String, CodingKey {
            case index = "categoryIdx"
            case name = "categoryName"
            case detailList = "detailCategoryList"
        }
    }
    
    public struct DetailCategoryList: Codable {
        public let detailIndex: Int
        public let detailName: String
        
        enum CodingKeys: String, CodingKey {
            case detailIndex = "detailCategoryIdx"
            case detailName = "detailCategoryName"
        }
        
        public init(detailIndex: Int, detailName: String) {
            self.detailIndex = detailIndex
            self.detailName = detailName
        }
    }
}

extension CategoryInfo.Result: Equatable {}

extension CategoryInfo.DetailCategoryList: Equatable {}
