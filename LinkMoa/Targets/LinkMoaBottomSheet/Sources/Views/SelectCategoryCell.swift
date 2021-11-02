//
//  SelectCategoryCell.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/17.
//

import UIKit

final class SelectCategoryCell: UICollectionViewCell {
    public static let cellIdentifier: String = "SelectCategoryCell"
    
    @IBOutlet public weak var titleLabel: UILabel!

    public override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                titleLabel.textColor = UIColor.white
                backgroundColor = UIColor.linkMoaDarkBlueColor
            } else {
                titleLabel.textColor = UIColor.linkMoaCategoryOptionBlackColor
                backgroundColor = UIColor.linkMoaOptionBackgroundColor
            }
        }
    }
    
    public var isSelectedCell: Bool = false {
        didSet {
            if self.isSelectedCell {
                titleLabel.textColor = UIColor.white
                backgroundColor = UIColor.linkMoaDarkBlueColor
            } else {
                titleLabel.textColor = UIColor.linkMoaCategoryOptionBlackColor
                backgroundColor = UIColor.linkMoaOptionBackgroundColor
            }
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        prepareLayer()
    }
    
    private func prepareLayer() {
        layer.masksToBounds = true
        layer.cornerRadius = 8
    }
    
    public func update(title: String) {
        titleLabel.text = title
    }
}
