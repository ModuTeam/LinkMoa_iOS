//
//  SurfingHeaderView.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/05.
//

import UIKit

class SurfingHeaderView: UICollectionReusableView {

    static let reuseableViewIndetifier: String = "SurfingHeaderView"
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
