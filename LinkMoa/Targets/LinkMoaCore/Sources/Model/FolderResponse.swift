//
//  FolderResponse.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/08.
//

import Foundation

/// 폴더 수정, 폴더 삭제
public struct FolderResponse: Codable {
    public let isSuccess: Bool
    public let code: Int
    public let message: String
}
