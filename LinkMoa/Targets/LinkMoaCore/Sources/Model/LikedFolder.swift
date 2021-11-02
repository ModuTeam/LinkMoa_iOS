//
//  LikedFolder.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/08.
//

import Foundation

/// 좋아요한 폴더 조회(리스트)
public struct LikedFolder: Codable {
    public let isSuccess: Bool
    public let code: Int
    public let message: String
    public let result: [IntegratedFolder]?
}
