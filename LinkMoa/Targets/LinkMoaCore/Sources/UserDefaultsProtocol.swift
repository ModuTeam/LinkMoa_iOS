//
//  UserDefaultsProtocol.swift
//  LinkMoaCore
//
//  Created by won heo on 2021/11/20.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation

public protocol UserDefaultsProtocol {
    func value(forKey key: String) -> Any?
    func setValue(_ value: Any?, forKey key: String)
}
