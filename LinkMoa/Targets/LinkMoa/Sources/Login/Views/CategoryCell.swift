//
//  CategoryCell.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/05.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import LinkMoaKit
import UIKit

final class CategoryCell: UICollectionViewCell, Reusable {
    @IBOutlet public weak var titleLabel: UILabel!
    
    var detailCategory: DetailCategory?
    
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
    
    public func update(by detailCategory: DetailCategory) {
        self.detailCategory = detailCategory
        titleLabel.text = detailCategory.name
    }
}
