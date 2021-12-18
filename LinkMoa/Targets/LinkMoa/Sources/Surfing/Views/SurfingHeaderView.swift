//
//  SurfingHeaderView.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/05.
//

import UIKit
import LinkMoaKit
import SnapKit

final class SurfingHeaderView: UICollectionReusableView, Reusable {

    let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x364788), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = UIColor(rgb: 0x364788)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansMedium(size: 18)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(moreButton)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self).inset(18)
            make.height.equalTo(27)
            make.centerY.equalTo(self)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self).inset(18)
        }
    }
}
