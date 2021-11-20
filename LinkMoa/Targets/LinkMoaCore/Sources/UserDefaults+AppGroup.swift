//
//  UserDefaults+AppGroup.swift
//  LinkMoa
//
//  Created by won heo on 2021/09/06.
//

import Foundation

public extension UserDefaults {
    static let appGroupID = "group.com.makeus.modu.linkMoa"
    
    class var appGroup: UserDefaults {
        guard let userDefaults = UserDefaults(suiteName: UserDefaults.appGroupID) else {
            fatalError("App Group can't init")
        }
        
        return userDefaults
    }
}

extension UserDefaults: UserDefaultsProtocol {}
