//
//  AppleLogin.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/08.
//

import Foundation

public struct AppleLogin: Codable {
    public struct Response: Codable {
        public let isSuccess: Bool
        public let code: Int
        public let message: String
        public let result: Result?
    }
    
    public struct Result: Codable {
        public let jwt: String
        public let userIndex: Int?
        public let member: String
        
        enum CodingKeys: String, CodingKey {
            case userIndex = "userIdx"
            case jwt
            case member
        }
    }
}


public struct SocialLogin: Codable {
    public let isSuccess: Bool
    public let code: Int
    public let message: String
    public let result: Result?
    
    public struct Result: Codable {
        public let jwt: String
        public let userIndex: Int?
        public let member: String
        
        enum CodingKeys: String, CodingKey {
            case userIndex = "userIdx"
            case jwt
            case member
        }
    }
}
