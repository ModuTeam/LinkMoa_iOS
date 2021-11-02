//
//  TopTen.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/10.
//

import Foundation

public struct TopTenFolder: Codable {
    public let isSuccess: Bool
    public let code: Int
    public let userIndex: Int
    public let message: String
    public let result: [IntegratedFolder]
    
    enum CodingKeys: String, CodingKey {
        case userIndex = "userIdx"
        case isSuccess, code, message, result
    }
}
