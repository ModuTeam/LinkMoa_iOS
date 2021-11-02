//
//  RemoveRequestBottomViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/20.
//

import LinkMoaKit
import UIKit

import Toast_Swift

final class TextRequestViewController: UIViewController {
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var backGroundView: UIView!
    @IBOutlet private(set) weak var folderNameTextField: UITextField!
    @IBOutlet private weak var deleteButtonView: UIView!
    @IBOutlet private weak var bottomSpacingLayout: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var buttonLabel: UILabel!
        
    var blurVC: BackgroundBlur?
    var name: String?
    var completion: ((Any?) -> Void)?
    var removeRequest: TextRequest = .removeFolder
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        presentAndFadeIn()
        prepareBackgroundView()
        prepareBottomViewGesture()
        prepareDeleteButtonView()
        prepareFolderNameTextField()
        prepareTitleLabels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        prepareBottomViewRoundConer()
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }

    private func prepareTitleLabels() {
        switch removeRequest {
        case .editNickname:
            folderNameTextField.text = name
            titleLabel.text = "닉네임 변경"
            subTitleLabel.text = "변경하려는 닉네임을 입력해주세요."
            buttonLabel.text = "닉네임 변경"
        case .removeFolder:
            if let name = name {
                let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemRed]
                let firstString = NSMutableAttributedString(string: "삭제를 원하시면 ")
                let secondString = NSAttributedString(string: "\(name)", attributes: secondAttributes)
                let thirdString = NSAttributedString(string: "을 입력하세요.")
                
                firstString.append(secondString)
                firstString.append(thirdString)
                subTitleLabel.attributedText = firstString
            }
        }
    }
    
    private func prepareFolderNameTextField() {
        folderNameTextField.delegate = self
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: folderNameTextField.frame.height))
        folderNameTextField.leftView = paddingView
        folderNameTextField.leftViewMode = .always

        folderNameTextField.layer.masksToBounds = true
        folderNameTextField.layer.cornerRadius = 8
        
        if let folderName = name {
            folderNameTextField.attributedPlaceholder = NSAttributedString(string: folderName, attributes: [
                .foregroundColor: UIColor.linkMoaPlaceholderColor,
                .font: UIFont(name: "NotoSansCJKkr-Regular", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
            ])
        }
    }
    
    private func prepareDeleteButtonView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteButtonViewTapped))
        deleteButtonView.addGestureRecognizer(tapGesture)
        deleteButtonView.isUserInteractionEnabled = true
        
        deleteButtonView.layer.masksToBounds = true
        deleteButtonView.layer.cornerRadius = 8
        deleteButtonView.layer.borderWidth = 1
        deleteButtonView.layer.borderColor = UIColor.linkMoaRedColor.cgColor
    }
    
    private func prepareBottomViewRoundConer() {
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        bottomView.clipsToBounds = true
    }
    
    private func prepareBottomViewGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bottomViewTapped))
        tapGesture.cancelsTouchesInView = false
        bottomView.addGestureRecognizer(tapGesture)
        bottomView.isUserInteractionEnabled = true
    }
    
    private func prepareBackgroundView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        backGroundView.addGestureRecognizer(tapGesture)
        backGroundView.isUserInteractionEnabled = true
    }
    
    private func presentAndFadeIn() {
        blurVC?.fadeInBackgroundViewAnimation()
    }
    
    private func dismissAndFadeOut(completion: (() -> Void)? = nil) {
        blurVC?.fadeOutBackgroundViewAnimation()
        dismiss(animated: true, completion: {
            completion?()
        })
    }
    
    @objc private func backgroundViewTapped() {
        dismissAndFadeOut()
    }
    
    @IBAction func dismissButtonTapped() {
        dismissAndFadeOut()
    }
    
    @objc private func bottomViewTapped() {
        folderNameTextField.resignFirstResponder()
    }
        
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomSpacingLayout.constant = keyboardHeight
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSpacingLayout.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func deleteButtonViewTapped() {
        switch removeRequest {
        case .removeFolder:
            guard let name = name, let text = folderNameTextField.text else { return }
            
            if name != text {
                view.makeToast("올바른 폴더 이름을 입력해주세요.", position: .top)
                return
            }
            
            self.completion?(nil)
            dismissAndFadeOut()
        
        case .editNickname:
            guard let oldName = name else { return }
            guard let nickname = folderNameTextField.text else { return }
            
            if nickname.isEmpty {
                view.makeToast("닉네임을 입력해주세요.", position: .top)
                return
            }
            
            if oldName == nickname {
                view.makeToast("동일한 닉네임으로 변경할 수 없습니다.", position: .top)
                return
            }
            
            self.completion?(nickname)
            dismissAndFadeOut()
        }
    }
}

extension TextRequestViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
