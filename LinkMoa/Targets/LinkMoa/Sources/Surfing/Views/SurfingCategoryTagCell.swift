//
//  SurfingCategoryTagCell.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/17.
//

import LinkMoaCore
import UIKit

final class SurfingCategoryTagCell: UICollectionViewCell {
    static let cellIdentifier: String = "SurfingCategoryTagCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // color 5E6CA0 , size 1.5
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 17
        containerView.backgroundColor = .linkMoaDarkBlueColor
        titleLabel.textColor = UIColor.init(rgb: 0x8896CC)
        containerView.layer.borderWidth = 1.5
        containerView.layer.borderColor = UIColor.init(rgb: 0x8896CC).cgColor
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                containerView.backgroundColor = .white
                titleLabel.textColor = .linkMoaDarkBlueColor
                containerView.layer.borderWidth = 1.5
                containerView.layer.borderColor = UIColor.white.cgColor
            } else {
                containerView.backgroundColor = .linkMoaDarkBlueColor
                titleLabel.textColor = UIColor.init(rgb: 0x8896CC)
                containerView.layer.borderWidth = 1.5
                containerView.layer.borderColor = UIColor.init(rgb: 0x8896CC).cgColor
            }
        }
    }
    
    func update(by categories: CategoryInfo.DetailCategoryList) {
        titleLabel.text = categories.detailName
    }

}
