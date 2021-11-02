//
//  LinkMoaNavigationController.swift
//  LinkMoa
//
//  Created by won heo on 2021/09/06.
//

import UIKit

open class LinkMoaNavigationController: UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        prepareNavigationBar()
    }
    
    open func prepareNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.clear
        
        let edgeInset = UIEdgeInsets(top: 0, left: -10, bottom: -3, right: 0)
        let image = UIImage(systemName: "chevron.left")?.withAlignmentRectInsets(edgeInset)
        
        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
    }
}

extension LinkMoaNavigationController: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
    
    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
