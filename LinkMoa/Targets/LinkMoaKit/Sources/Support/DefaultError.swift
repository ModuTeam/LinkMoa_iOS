//
//  DefaultError.swift
//  LinkMoa
//
//  Created by won heo on 2021/06/28.
//

import Foundation

public enum DefaultError: LocalizedError {
    case flatmap
    case network
    
    public var errorDescription: String? {
        switch self {
        case .flatmap:
            return "예상치 못한 에러가 발생했습니다."
        case .network:
            return "서버 에러가 발생했습니다."
        }
    }
}
