//
//  LinkCell.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/17.
//

import LinkMoaCore
import LinkMoaKit
import UIKit

import RxSwift
import Kingfisher

final class LinkCell: UICollectionViewCell, Reusable {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!
    @IBOutlet private weak var faviconImageView: UIImageView!
    @IBOutlet private(set) weak var editButton: UICustomTagButton!
    @IBOutlet private(set) weak var dotImageView: UIImageView!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.05
        layer.shadowRadius = 20
    }
    
    override func prepareForReuse() {
        resetComponents()
        disposeBag = DisposeBag()
    }
    
    private func resetComponents() {
        nameLabel.text = nil
        urlLabel.text = nil
        faviconImageView.image = nil
    }
    
    func update(by link: FolderDetail.Link, isHiddenEdit: Bool = false) {
        dotImageView.isHidden = isHiddenEdit
        nameLabel.text = link.name
        urlLabel.text = link.url
        editButton.customTag = link.index
        
        if let url = URL(string: link.faviconURL), link.faviconURL != "-1" {
            faviconImageView.kf.setImage(with: url, placeholder: UIImage(named: "seashell"))
        }
    }
    
    // MARK: - Surfing & Search
    func update(by link: SearchLink.Result, isHiddenEdit: Bool = false) {
        dotImageView.isHidden = isHiddenEdit
        nameLabel.text = link.name
        urlLabel.text = link.url
        
        if let url = URL(string: link.faviconURL), link.faviconURL != "-1" {
            faviconImageView.kf.setImage(with: url, placeholder: UIImage(named: "seashell"))
        }
    }
}
