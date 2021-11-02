//
//  HomeNavigationController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/07.
//

import UIKit
import LinkMoaBottomSheet

import RxCocoa
import RxGesture

final class HomeNavigationController: LinkMoaNavigationController, BackgroundBlur {
    let addButtonView: UIView = {
        let addButtonView = UIView()
        addButtonView.translatesAutoresizingMaskIntoConstraints = false
        addButtonView.backgroundColor = .linkMoaDarkBlueColor
        addButtonView.layer.masksToBounds = true
        addButtonView.layer.cornerRadius = 63 / 2
        return addButtonView
    }()
    
    private let plusImageView: UIImageView = {
        let plusImageView = UIImageView(image: UIImage(systemName: "plus"))
        plusImageView.tintColor = .white
        plusImageView.translatesAutoresizingMaskIntoConstraints = false
        return plusImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAddButonView()
    }
    
    private func prepareAddButonView() {
        addButtonView.addSubview(plusImageView)
        view.addSubview(addButtonView)
            
        NSLayoutConstraint.activate([
            plusImageView.widthAnchor.constraint(equalToConstant: 28),
            plusImageView.heightAnchor.constraint(equalToConstant: 28),
            plusImageView.centerXAnchor.constraint(equalTo: addButtonView.centerXAnchor),
            plusImageView.centerYAnchor.constraint(equalTo: addButtonView.centerYAnchor),
            addButtonView.widthAnchor.constraint(equalToConstant: 63),
            addButtonView.heightAnchor.constraint(equalToConstant: 63),
            addButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -39),
            addButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -39)
        ])
    }
}
