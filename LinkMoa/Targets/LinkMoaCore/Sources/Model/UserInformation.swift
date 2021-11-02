//
//  UserInformation.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/17.
//

import Foundation

public struct UserInformation: Codable {
    public let isSuccess: Bool
    public let code: Int
    public let message: String
    public let result: [Result]?
    
    public struct Result: Codable {
        public let index, strategy: Int
        public let nickname, email: String
        public let profileImgURL: String
        public let categoryIndex: Int
        
        enum CodingKeys: String, CodingKey {
            case index = "userIdx"
            case strategy = "userStrategy"
            case nickname = "userNickname"
            case email = "userEmail"
            case profileImgURL = "userProfileImgUrl"
            case categoryIndex = "userCategoryIdx"
        }
    }
}

extension UserInformation.Result: Equatable {}
