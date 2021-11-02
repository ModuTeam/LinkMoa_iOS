//
//  RegisterCategoryViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/18.
//

import LinkMoaCore
import UIKit

final class RegisterCategoryViewController: UIViewController {
    // MVC
    @IBOutlet private weak var nextButtonView: UIView!
    @IBOutlet private weak var nextButtonLabel: UILabel!
    @IBOutlet private weak var categoryStackView: UIStackView!
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var currentProgressView: UIView!
    @IBOutlet private var categoryHeightConstarintLayouts: [NSLayoutConstraint]!
    
    // Dependency Injection
    private let registerDataManager: RegisterDataManager
    
    init?(coder: NSCoder, registerDataManager: RegisterDataManager) {
        self.registerDataManager = registerDataManager
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        prepareProgressViews()
        prepareStackViewSubviews()
        prepareNextButtonView()
    }
    
    private func prepareStackViewSubviews() {
        for subview in categoryStackView.subviews {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryTapped(_:)))
            subview.addGestureRecognizer(tapGesture)
            subview.isUserInteractionEnabled = true
            subview.layer.masksToBounds = true
            subview.layer.cornerRadius = 8
        }
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136, 1334:
                for height in categoryHeightConstarintLayouts {
                    height.constant = 60
                }
            default:
                break
            }
        }
    }
    
    private func prepareProgressViews() {
        progressView.layer.masksToBounds = true
        progressView.layer.cornerRadius = 2
        currentProgressView.layer.masksToBounds = true
        currentProgressView.layer.cornerRadius = 2
    }
    
    private func prepareNextButtonView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextButtonViewTapped))
        nextButtonView.isUserInteractionEnabled = false
        nextButtonView.addGestureRecognizer(tapGesture)
        nextButtonView.layer.masksToBounds = true
        nextButtonView.layer.cornerRadius = 8
    }
    
    @objc private func categoryTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        registerDataManager.categoryIndex = view.tag

        categoryStackView.subviews.forEach {
            $0.layer.opacity = $0.tag != view.tag ? 0.3 : 1
        }
        
        nextButtonLabel.textColor = UIColor.white
        nextButtonView.backgroundColor = UIColor.linkMoaDarkBlueColor
        nextButtonView.isUserInteractionEnabled = true
    }
    
    @objc private func nextButtonViewTapped() {
        presentDetailCategory()
    }
}

// MARK:- Present
extension RegisterCategoryViewController {
    func presentDetailCategory() {
        let vc: RegisterDetailCategoryViewController = DIContainer.shared.resolve(
            argument: registerDataManager
        )
        navigationController?.pushViewController(vc, animated: true)
    }
}
