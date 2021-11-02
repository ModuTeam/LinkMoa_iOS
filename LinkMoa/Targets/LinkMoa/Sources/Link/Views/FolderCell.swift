//
//  HomeFolderCellCell.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/03.
//

import LinkMoaCore
import LinkMoaKit
import UIKit

import RxSwift
import Kingfisher

final class FolderCell: UICollectionViewCell, IdentifierType {
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = webPreviewImageView.bounds
        return layer
    }()
    
    lazy var resizeProcessor: ResizingImageProcessor = {
        let processor = ResizingImageProcessor(
            referenceSize: CGSize(width: self.frame.width, height: self.frame.height),
            mode: .aspectFit
        )
        return processor
    }()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var webPreviewImageView: UIImageView!
    @IBOutlet private weak var lockImageView: UIImageView!
    @IBOutlet weak var editButton: UICustomTagButton!
    @IBOutlet weak var heartStackView: UIStackView!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var editImageView: UIImageView!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 10
        addGradientLayer()
        heartStackView.isHidden = true
    }
    
    override func prepareForReuse() {
        resetComponents()
        disposeBag = DisposeBag()
    }
    
    private func resetComponents() {
        webPreviewImageView.image = nil
        lockImageView.isHidden = true
    }
    
    // MARK: - My
    func update(by folder: FolderList.Result, isLowImageMode: Bool = false) {
        titleLabel.text = folder.name
        countLabel.text = String(folder.linkCount)
        editButton.customTag = folder.index
        
        let isShared = folder.folderType == "private" ? false : true
        lockImageView.isHidden = isShared
        
        if let url = URL(string: folder.imageURL), folder.imageURL != "-1" {
            let options: [KingfisherOptionsInfoItem] = isLowImageMode ? [.processor(resizeProcessor)] : []
            webPreviewImageView.kf.setImage(with: url, options: options)
        }
    }

    // MARK: - Surfing & Search
    func update(by folder: IntegratedFolder, isHiddenLike: Bool = false) {
        prepareSurfingFolder()
        heartStackView.isHidden = isHiddenLike
        titleLabel.text = folder.folderName
        countLabel.text = folder.linkCount.toAbbreviationString
        likeCountLabel.text = folder.likeCount.toAbbreviationString
        
        if folder.likeStatus == 1 {
            heartImageView.image = UIImage(systemName: "heart.fill")
        } else {
            heartImageView.image = UIImage(systemName: "heart")
        }
        
        if let linkImageURL = folder.linkImageURL, let url = URL(string: linkImageURL), linkImageURL != "-1" {
            webPreviewImageView.kf.setImage(with: url)
        }
    }
    
    func prepareSurfingFolder() {
        lockImageView.isHidden = true
        gradientLayer.isHidden = false
        heartStackView.isHidden = false
        editImageView.isHidden = true
    }
    
    func addGradientLayer() {
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let screenSize: CGFloat = UIScreen.main.bounds.width
        
        webPreviewImageView.frame.size.width = (screenSize - 16 * 3) / 2

        gradientLayer.frame = webPreviewImageView.bounds
        gradientLayer.mask = shapeLayer
        gradientLayer.colors = [UIColor.init(rgb: 0x303030).withAlphaComponent(0.4).cgColor, UIColor.white.withAlphaComponent(0.4).cgColor]
        
        let path = UIBezierPath(roundedRect: webPreviewImageView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
        shapeLayer.path = path.cgPath
        
        webPreviewImageView.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.isHidden = true
    }
}
