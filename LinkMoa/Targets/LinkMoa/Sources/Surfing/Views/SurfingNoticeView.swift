//
//  SurfingNoticeView.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/12/30.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import UIKit
import LinkMoaKit

final class SurfingNoticeView: UIView {
    
    let noticeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let noticeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "seeshelCharacter")
        return imageView
    }()
    
    let noticeLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansRegular(size: 16)
        label.textColor = .linkMoaFolderCountGrayColor
        return label
    }()
    
    private var message: String = ""
    
    required init(message: String) {
        super.init(frame: .zero)
        self.message = message
        noticeLabel.text = message
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(noticeStackView)
        noticeStackView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
        }
        
        noticeStackView.addArrangedSubview(noticeImageView)
        noticeStackView.addArrangedSubview(noticeLabel)
        noticeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
    }
    
}
