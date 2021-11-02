//
//  ReconfirmBottomViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/16.
//

import UIKit
import LinkMoaKit

typealias ReconfirmTuple = (title: String, message: String, buttonTitle: String)

final class ReconfirmViewController: UIViewController {
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var reportLabel: UILabel!
    @IBOutlet private weak var reportButtonView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var buttonLabel: UILabel!
    
    private let titleMessage: [Reconfirm: ReconfirmTuple] = [
        .reportFolder: ("신고하기", "링크달을 신고하시겠습니까?", "신고하기"),
        .logout: ("로그아웃", "로그아웃 하시겠습니까?", "로그아웃"),
        .deleteAccount: ("탈퇴하기", "탈퇴 후에는 복구가 불가능하며 작성한 모든 데이터를 삭제하거나 수정할 수 없습니다.", "동의 후 탈퇴하기")
    ]
    
    var reconfirm: Reconfirm = .reportFolder
    var completion: (() -> Void)?
    var folderIndex: Int?
    var blurVC: BackgroundBlur?
      
    override func viewDidLoad() {
        super.viewDidLoad()
        presentAndFadeIn()
        prepareUI()
        prepareBackgroundView()
        prepareDeleteButtonView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        prepareBottomViewRoundConer()
    }
    
    private func prepareUI() {
        guard let titleMessage = titleMessage[reconfirm] else { return }
        titleLabel.text = titleMessage.title
        reportLabel.text = titleMessage.message
        buttonLabel.text = titleMessage.buttonTitle
    }
    
    private func prepareDeleteButtonView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(reportButtonViewTapped))
        reportButtonView.addGestureRecognizer(tapGesture)
        reportButtonView.isUserInteractionEnabled = true
        reportButtonView.layer.masksToBounds = true
        reportButtonView.layer.cornerRadius = 8
        reportButtonView.layer.borderWidth = 1
        reportButtonView.layer.borderColor = UIColor.linkMoaRedColor.cgColor
    }
    
    private func prepareBottomViewRoundConer() {
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        bottomView.clipsToBounds = true
    }
    
    private func prepareBackgroundView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.isUserInteractionEnabled = true
    }
    
    @objc func reportButtonViewTapped() {
        completion?()
        dismissAndFadeOut()
    }
    
    private func presentAndFadeIn() {
        blurVC?.fadeInBackgroundViewAnimation()
    }
    
    private func dismissAndFadeOut() {
        blurVC?.fadeOutBackgroundViewAnimation()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func backgroundViewTapped() {
        dismissAndFadeOut()
    }

    @IBAction private func dismissButtonTapped() {
        dismissAndFadeOut()      
    }
}
