//
//  SurfingSearchHeaderView.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/19.
//

import UIKit
import LinkMoaKit
import SnapKit

final class SurfingSearchHeaderView: UICollectionReusableView, Reusable {
    
    let searchView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(rgb: 0xe9e9e9).cgColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search")
        return imageView
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "다른 유저의 링크달을 조회하세요."
        label.font = .notoSansMedium(size: 18)
        label.textColor = UIColor(rgb: 0xE0E0E0)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TOP10 링크달"
        label.font = .notoSansMedium(size: 18)
        return label
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x364788), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = UIColor(rgb: 0x364788)
        return button
    }()
    
    let titleHeaderView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(searchView)
        searchView.addSubview(imageView)
        searchView.addSubview(placeholderLabel)
        
        searchView.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(16)
            make.top.equalTo(self).inset(20)
            make.height.equalTo(53)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(19)
            make.left.equalTo(searchView).inset(16)
            make.centerY.equalTo(searchView)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalTo(searchView).inset(10)
            make.centerY.equalTo(searchView)
        }
        
        addSubview(titleHeaderView)
        titleHeaderView.addSubview(titleLabel)
        titleHeaderView.addSubview(moreButton)
        
        titleHeaderView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(53)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(titleHeaderView).inset(18)
            make.height.equalTo(27)
            make.centerY.equalTo(titleHeaderView)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleHeaderView)
            make.right.equalTo(titleHeaderView).inset(18)
        }
    }
}
