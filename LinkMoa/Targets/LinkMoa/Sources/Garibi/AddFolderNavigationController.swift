//
//  AddFolderNavigationController.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/17.
//

import LinkMoaBottomSheet
import UIKit

final class AddFolderNavigationController: UINavigationController, BackgroundBlur {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
    }
}
