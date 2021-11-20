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

public class TokenManager {
    @TokenStorage(key: TokenType.jwt.rawValue)
    public var jwt: String?
    
    @TokenStorage(key: TokenType.userIndex.rawValue)
    public var userIndex: Int?
    
    @TokenStorage(key: TokenType.browser.rawValue)
    public var isUsingCustomBrowser: Bool?
    
    public init() {}
}

@propertyWrapper
public struct TokenStorage<T> {
    public let userDefaults: UserDefaultsProtocol
    public let key: String

    public init(userDefaults: UserDefaultsProtocol = UserDefaults.appGroup, key: String) {
        self.userDefaults = userDefaults
        self.key = key
    }
    
    public var wrappedValue: T? {
        get {
            return userDefaults.value(forKey: key) as? T
        }
        set {
            userDefaults.setValue(newValue, forKey: key)
        }
    }
}
