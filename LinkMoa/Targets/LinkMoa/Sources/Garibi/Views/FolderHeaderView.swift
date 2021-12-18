//
//  FolderheaderView.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/03.
//

import LinkMoaKit
import UIKit

import RxSwift

final class FolderHeaderView: UICollectionReusableView, Reusable {
    @IBOutlet private(set) weak var searchView: UIView!
    @IBOutlet private(set) weak var countTitleLabel: UILabel!
    @IBOutlet private(set) weak var sortButton: UIButton!
    @IBOutlet private(set) weak var sortLabel: UILabel!
    
    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = UIColor(rgb: 0xe9e9e9).cgColor
        searchView.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func update(by count: Int) {
        guard let font = UIFont(name: "NotoSansKR-Regular", size: 14) else { return }
        
        let folderString = "\(count)개의 폴더"
        let mutableString = NSMutableAttributedString(
            string: folderString,
            attributes: [NSAttributedString.Key.font: font]
        )
        mutableString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.linkMoaFolderCountGrayColor,
            range: NSRange(location: folderString.count - 4, length: 4)
        )
        countTitleLabel.attributedText = mutableString
    }
}
