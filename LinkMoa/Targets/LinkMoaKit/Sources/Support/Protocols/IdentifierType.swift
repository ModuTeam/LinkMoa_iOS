//
//  IdentifierType.swift
//  LinkMoa
//
//  Created by won heo on 2021/09/07.
//

import Foundation

public protocol IdentifierType: AnyObject {}

public extension IdentifierType {
    static var cellIdentifier: String {
        return String(describing: self)
    }
    
    static var viewIdentifier: String {
        return String(describing: self)
    }
}
