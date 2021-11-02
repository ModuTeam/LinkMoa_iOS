//
//  SurfingCategoryCell.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/05.
//

import UIKit

class SurfingCategoryCell: UICollectionViewCell {

    static let cellIdentifier: String = "SurfingCategoryCell"
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    private let categoryMain: [String] = ["개발", "디자인", "마케팅/광고", "기획", "기타"]
    private let categorySub: [String] = ["개발과 관련된 가리비 모음", "디자인과 관련된 가리비 모음", "마케팅/광고와 관련된 가리비 모음", "기획과 관련된 가리비 모음", "기타 가리비 모음"]
    
    var index: Int = 0 {
        didSet {
            titleLabel.text = categoryMain[index]
            subTitleLabel.text = categorySub[index]
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImageView.layer.cornerRadius = 65/2
        categoryImageView.contentMode = .scaleAspectFill
     
    }

}
