//
//  SurfingFooterView.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/19.
//

import UIKit
import LinkMoaKit
import SnapKit

final class SurfingFooterView: UICollectionReusableView, Reusable {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "garibiWithSad")
        return imageView
    }()
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 아무것도 찜하지 않았어요."
        label.font = .notoSansRegular(size: 16)
        label.textColor = UIColor(rgb: 0x909090)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
    }
}
