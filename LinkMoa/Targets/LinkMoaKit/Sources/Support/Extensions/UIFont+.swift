//
//  UIFont+.swift
//  LinkMoaKit
//
//  Created by Beomcheol Kwon on 2021/12/18.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import UIKit

public extension UIFont {
    
    static func notoSansMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansKR-Medium", size: size) ?? UIFont.systemFont(ofSize: 16)
    }
}
