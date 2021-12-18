//
//  Reusable.swift
//  LinkMoa
//
//  Created by won heo on 2021/09/07.
//

import Foundation

public protocol Reusable: AnyObject {}

public extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}
