//
//  NibLoadable+.swift
//  LinkMoaKit
//
//  Created by Beomcheol Kwon on 2021/12/28.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import UIKit

public protocol NibLoadable: AnyObject {
    static var nibName: String { get }
}

public extension NibLoadable where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

