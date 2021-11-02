//
//  SearchFolder.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/10.
//

import Foundation

public struct SearchFolder: Codable {
    public let isSuccess: Bool
    public let code, userIndex: Int
    public let message: String
    public let resultCount: Int
    public let result: [IntegratedFolder]?
    
    enum CodingKeys: String, CodingKey {
        case isSuccess, code
        case userIndex = "userIdx"
        case message, resultCount, result
    }
}
