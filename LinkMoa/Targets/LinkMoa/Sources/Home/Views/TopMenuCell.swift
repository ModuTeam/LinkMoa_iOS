//
//  TopMenuCell.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/02.
//

import LinkMoaKit
import UIKit

final class TopMenuCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.layer.opacity = isSelected ? 1 : 0.3
            titleLabel.textColor = isSelected ? .linkMoaBlackColor : .linkMoaGrayColor
        }
    }
}
