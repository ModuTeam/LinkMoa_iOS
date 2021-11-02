//
//  NewFolder.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/08.
//

import Foundation

/// 폴더 생성
public struct NewFolder: Codable {
    public let isSuccess: Bool
    public let code: Int
    public let index: Int
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case isSuccess, code
        case index = "folderIdx"
        case message
    }
}
