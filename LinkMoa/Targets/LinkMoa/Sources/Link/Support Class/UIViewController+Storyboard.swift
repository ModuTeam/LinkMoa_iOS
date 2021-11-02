//
//  UIViewController+Storyboard.swift
//  LinkMoa
//
//  Created by won heo on 2021/09/15.
//  Copyright © 2021 com.modu.LinkMoa. All rights reserved.
//

import UIKit

extension UIViewController {
    static func storyboardName() -> String {
        return String(describing: self)
            .replacingOccurrences(of: "ViewController", with: "")
            .replacingOccurrences(of: "NavigationController", with: "")
    }
    
    static func storyboardInstance() -> Self? {
        let storyboard = UIStoryboard(name: Self.storyboardName(), bundle: Bundle.module)
        return storyboard.instantiateInitialViewController()
    }
}
