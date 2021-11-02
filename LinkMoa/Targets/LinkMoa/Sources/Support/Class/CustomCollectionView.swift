//
//  CustomCollectionView.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/27.
//

import UIKit

class CustomCollectionView: UICollectionView {
    private var reloadDataCompletionBlock: (() -> Void)?
    
    func reloadDataWithCompletion(_ complete: @escaping () -> Void) {
        reloadDataCompletionBlock = complete
        super.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let block = reloadDataCompletionBlock {
            block()
        }
    }
}
