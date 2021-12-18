//
//  MyPageViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/16.
//

import LinkMoaBottomSheet
import LinkMoaCore
import LinkMoaKit
import MessageUI
import UIKit

import Carte
import RxCocoa
import RxSwift
import Toast_Swift

enum MyPageSection: Int {
    case faq
    case mail
    case web
    case appVersion
    case openSource
    case resign
}

final class MyPageViewController: UIViewController, CustomAlert, BackgroundBlur {
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var editNicknameButton: UIButton!
    @IBOutlet private weak var menuTableView: UITableView!
    
    private lazy var composeVC: MFMailComposeViewController = {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = self
        vc.setToRecipients(["moduteamdev@gmail.com"])
        vc.setSubject("LinkMoa feedback")
        vc.setMessageBody(
            "iOS version: \(Constant.iOSVersion!), App version: \(Constant.appVersion!).",
            isHTML: false
        )
        return vc
    }()
    
    private var mailMessage: [MFMailComposeResult: String] = [
        .saved: "메일이 저장되었습니다.",
        .sent: "소중한 의견 감사합니다.",
        .failed: "다시 시도해주세요."
    ]
        
    private lazy var inputs = MyPageViewModel.Input(
        fetchUserNickname: fetchUserNickname.asSignal(),
        useSafariToggle: safariToggleAction.asSignal(),
        changeUserNickName: changeNicknameAction.asSignal(),
        logout: logoutAction.asSignal(),
        deleteUser: deleteAction.asSignal()
    )
    private lazy var outputs = viewModel.transform(input: inputs)
    private let disposeBag = DisposeBag()

    // MARK: - Action
    private let changeNicknameAction = PublishRelay<String>()
    private let safariToggleAction = PublishRelay<Bool>()
    private let logoutAction = PublishRelay<Void>()
    private let deleteAction = PublishRelay<Void>()
    private let fetchUserNickname = PublishRelay<Void>()
    
    // Dependency Injection
    private let viewModel: MyPageViewModel
    
    init?(coder: NSCoder, viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserNickname.accept(())
    }
    
    // MARK: - Methods
    private func bind() {
        outputs.bottomAlert
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.presentImageAlertView()
            }
            .disposed(by: disposeBag)
        
        outputs.toastMessage
            .emit { [weak self] message in
                guard let self = self else { return }
                self.view.makeToast(message, position: .top)
            }
            .disposed(by: disposeBag)

        // nicknameLabel
        outputs.userNickName
            .drive(nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        // menuTableView
        outputs.settingMenus
            .drive(menuTableView.rx.items(cellIdentifier: MyPageCell.identifier)) {
                [weak self] (index: Int, title: String, cell: MyPageCell) -> Void in
                guard let self = self else { return }
                guard let section = MyPageSection(rawValue: index) else { return }
                cell.titleLabel.text = title
                
                switch section {
                case .web:
                    self.outputs.isUseSafari
                        .drive(cell.browserSwitch.rx.isOn)
                        .disposed(by: cell.disposeBag)
            
                    cell.browserSwitch.rx.isOn
                        .bind(to: self.safariToggleAction)
                        .disposed(by: cell.disposeBag)
                    
                    cell.browserSwitch.isHidden = false
                case .appVersion:
                    cell.subTitleLabel.isHidden = false
                    cell.subTitleLabel.text = Constant.appVersion
                case .resign:
                    cell.titleLabel.textColor = UIColor.linkMoaRedColor
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        menuTableView.rx.itemSelected
            .subscribe { [weak self] (indexPath: IndexPath) -> Void in
                guard let self = self else { return }
                guard let section = MyPageSection(rawValue: indexPath.row) else { return }
                
                switch section {
                case .faq:
                    let faqVC: FAQViewController = DIContainer.shared.resolve()
                    faqVC.modalPresentationStyle = .fullScreen
                    self.present(faqVC, animated: true)
                case .mail:
                    self.composeMailVC()
                case .openSource:
                    let openSourceNC: OpenSourceNavigationController = DIContainer.shared.resolve()
                    openSourceNC.modalPresentationStyle = .fullScreen
                    self.present(openSourceNC, animated: true)
                case .resign:
                    self.deleteAccount()
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        editNicknameButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.presentTextRequestView(
                    type: .editNickname,
                    name: self.viewModel.nickName
                ) { [weak self] (nickName: Any) in
                    guard let self = self else { return }
                    guard let nickName = nickName as? String else { return }
                    self.changeNicknameAction.accept(nickName)
                }
            }
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.presentReconfirmView(type: .logout) {
                    self.moveLoginVC()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareMenuTableView()
        prepareNavigationItem()
        prepareLogoutButton()
    }
    
    private func prepareLogoutButton() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "로그아웃", attributes: underlineAttribute)
        logoutButton.setAttributedTitle(underlineAttributedString, for: .normal)
    }
    
    private func prepareNavigationItem() {
        let backBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backNaviButtonTapped)
        )
        backBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        backBarButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func prepareMenuTableView() {
        let nib = UINib(nibName: MyPageCell.identifier, bundle: nil)
        menuTableView.register(nib, forCellReuseIdentifier: MyPageCell.identifier)
    }
    
    private func composeMailVC() {
        guard MFMailComposeViewController.canSendMail() else {
            view.makeToast("메일 서비스를 사용할 수 없습니다.", duration: 1.0, position: .top)
            return
        }
        
        present(composeVC, animated: true)
    }
    
    @objc private func backNaviButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK:- Coordinate
extension MyPageViewController {
    private func deleteAccount() {
        presentReconfirmView(type: .deleteAccount) { [weak self] in
            guard let self = self else { return }
            self.deleteAction.accept(())
            self.moveLoginVC()
        }
    }
    
    private func moveLoginVC() {
        let window: UIWindow = DIContainer.shared.resolve()
        let loginVC: LoginViewController = DIContainer.shared.resolve()
        window.rootViewController = loginVC
        window.makeKeyAndVisible()
        
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        ) { _ in
            self.logoutAction.accept(()) // token 삭제
        }
    }
}

// MAKR:- MFMailComposeViewControllerDelegate
extension MyPageViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        if let _ = error {
            // ERROR_LOG(error.localizedDescription)
            return
        }
        
        dismiss(animated: true) {
            if let message = self.mailMessage[result] {
                self.view.makeToast(message, duration: 1.0, position: .top)
            }
        }
    }
}
