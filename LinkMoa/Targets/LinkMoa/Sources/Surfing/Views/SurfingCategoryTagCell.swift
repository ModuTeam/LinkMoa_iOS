//
//  SurfingCategoryTagCell.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/17.
//

import LinkMoaCore
import LinkMoaKit
import UIKit
import SnapKit

final class SurfingCategoryTagCell: UICollectionViewCell, Reusable {
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 17
        view.backgroundColor = .linkMoaDarkBlueColor
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor(rgb: 0x8896CC).cgColor
        return view
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(rgb: 0x8896CC)
        label.font = .notoSansMedium(size: 14)
        return label
    }()
    
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
                containerView.layer.borderColor = UIColor(rgb: 0x8896CC).cgColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    func update(by categories: CategoryInfo.DetailCategoryList) {
        titleLabel.text = categories.detailName
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(containerView.snp.center)
        }
    }

}
