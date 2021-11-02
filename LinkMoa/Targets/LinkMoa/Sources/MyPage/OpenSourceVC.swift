//
//  OpenSourceVC.swift
//  LinkMoa
//
//  Created by won heo on 2021/09/06.
//

import Foundation

import Carte

final class OpenSourceViewController: CarteViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        let edgeInset = UIEdgeInsets(top: 0, left: -10, bottom: -3, right: 0)
        let image = UIImage(systemName: "chevron.left")?.withAlignmentRectInsets(edgeInset)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(doneButtonDidTap)
        )
    }
}
