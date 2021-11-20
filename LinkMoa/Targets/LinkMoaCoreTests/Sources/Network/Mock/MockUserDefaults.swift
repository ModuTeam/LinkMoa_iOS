//
//  MockUserDefaults.swift
//  LinkMoaCore
//
//  Created by won heo on 2021/11/20.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation

@testable import LinkMoaCore

class MockUserDefaults: UserDefaultsProtocol {
    var cache: [String: Any?] = [:]
    
    func value(forKey key: String) -> Any? {
        return cache[key] as Any?
    }
    
    func setValue(_ value: Any?, forKey key: String) {
        cache[key] = value
    }
}
