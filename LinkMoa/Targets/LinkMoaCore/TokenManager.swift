//
//  TokenManager.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/08.
//

import Foundation

public enum TokenType: String {
    case jwt
    case userIndex
    case browser
}

public struct TokenManager {
    public init() {}
    @TokenStorage(key: TokenType.jwt.rawValue) public var jwt: String?
    @TokenStorage(key: TokenType.userIndex.rawValue) public var userIndex: Int?
    @TokenStorage(key: TokenType.browser.rawValue) public var isUsingCustomBrowser: Bool?
}

@propertyWrapper
public struct TokenStorage<T> {
    public let key: String
    public var wrappedValue: T? {
        get {
            return UserDefaults.appGroup.value(forKey: key) as? T
        }
        set {
            UserDefaults.appGroup.setValue(newValue, forKey: key)
        }
    }
}
