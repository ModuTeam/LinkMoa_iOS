//
//  EditUserInformationResponse.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/19.
//

import Foundation

public struct EditUserInformationResponse: Codable {
    public let isSuccess: Bool
    public let code: Int
    public let userIndex: Int?
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case isSuccess, code
        case userIndex = "userIdx"
        case message
    }
}
