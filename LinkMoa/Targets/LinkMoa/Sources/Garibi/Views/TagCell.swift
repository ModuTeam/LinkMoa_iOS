//
//  TagCell.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/17.
//

import LinkMoaKit
import UIKit

final class TagCell: UICollectionViewCell, Reusable {
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 16
        layer.borderColor = UIColor.linkMoaDarkBlueColor.cgColor
        layer.borderWidth = 1
    }
    
    func update(by tagName: String) {
        nameLabel.text = tagName
    }
}
