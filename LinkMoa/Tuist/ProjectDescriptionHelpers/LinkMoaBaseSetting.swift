//
//  LinkMoaBaseSetting.swift
//  ProjectDescriptionHelpers
//
//  Created by won heo on 2021/09/24.
//

import ProjectDescription

public enum LinkMoaBaseSetting: String, CaseIterable {
    case projectVersion = "MARKETING_VERSION"
    case buildVersion = "CURRENT_PROJECT_VERSION"
    case signIdentity = "CODE_SIGN_IDENTITY"
    case signStyle = "CODE_SIGNING_STYLE"
    case developmentTeam = "DEVELOPMENT_TEAM"
    case signRequired = "CODE_SIGNING_REQUIRED"
    
    public var value: String {
        switch self {
        case .projectVersion:
            return "2.4"
        case .buildVersion:
            return "5"
        case .signIdentity:
            return "Apple Development"
        case .signStyle:
            return "Automatic"
        case .developmentTeam:
            return "HK54HM2TC6"
        case .signRequired:
            return "YES"
        }
    }
    
    public static func settings() -> [String: SettingValue] {
        var settingsDict: [String: SettingValue] = SettingsDictionary()
        
        self.allCases.forEach { key in
            settingsDict[key.rawValue] = SettingValue(stringLiteral: key.value)
        }
        
        return settingsDict
    }
}
