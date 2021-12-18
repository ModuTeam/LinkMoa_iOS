//
//  SurfingCategoryCell.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/05.
//

import UIKit
import LinkMoaKit
import SnapKit

final class SurfingCategoryCell: UICollectionViewCell, Reusable {

    let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 65/2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansMedium(size: 16)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let categoryMain = [
        "개발",
        "디자인",
        "마케팅/광고",
        "기획",
        "기타",
    ]
    
    private let categorySub = [
        "개발과 관련된 가리비 모음",
        "디자인과 관련된 가리비 모음",
        "마케팅/광고와 관련된 가리비 모음",
        "기획과 관련된 가리비 모음",
        "기타 가리비 모음",
    ]
    
    var index: Int = 0 {
        didSet {
            titleLabel.text = categoryMain[index]
            subTitleLabel.text = categorySub[index]
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
 
    private func setupUI() {
        addSubview(categoryImageView)
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        
        categoryImageView.snp.makeConstraints { make in
            make.width.height.equalTo(65)
            make.top.left.equalTo(self)
        }
        
        stackView.snp.makeConstraints { make in
            make.left.equalTo(categoryImageView.snp.right).offset(17)
            make.right.equalTo(self).inset(17)
            make.centerY.equalTo(self)
        }
    }
}
