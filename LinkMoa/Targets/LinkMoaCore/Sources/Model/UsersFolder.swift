//
//  UsersFolder.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/29.
//

import Foundation

public struct UsersFolder: Codable {
    public let isSuccess: Bool
    public let code: Int
    public let message: String
    public let result: [IntegratedFolder]?
}
