//
//  LinkResponse.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/08.
//

import Foundation

/// 폴더좋아요/취소, 링크 추가, 링크 수정, 링크 삭제
public struct LinkResponse: Codable {
    public let isSuccess: Bool
    public let code: Int
    public let index: Int
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case isSuccess, code
        case index = "userIdx"
        case message
    }
}
