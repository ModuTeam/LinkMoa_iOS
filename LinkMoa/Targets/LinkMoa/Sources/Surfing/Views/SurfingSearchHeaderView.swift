//
//  SurfingSearchHeaderView.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/19.
//

import UIKit

class SurfingSearchHeaderView: UICollectionReusableView {
    static let reuseableViewIndetifier: String = "SurfingSearchHeaderView"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var titleHeaderView: UIView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = UIColor(rgb: 0xe9e9e9).cgColor
        searchView.layer.cornerRadius = 8
    }
    
}
