//
//  RegisterNicknameViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/18.
//

import UIKit

import RxGesture
import RxRelay
import RxSwift
import Toast_Swift

final class RegisterNicknameViewController: UIViewController {
    @IBOutlet private weak var nicknameTextField: UITextField!
    @IBOutlet private weak var nicknameTextFieldBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nextButtonView: LinkMoaButtonView!
    @IBOutlet private weak var nextButtonLabel: LinkMoaButtonLabel!
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var currentProgressView: UIView!
    
    private lazy var input = RegisterNicknameViewModel.Input(
        registerNickname: registerNickname.asSignal(),
        nextButtonTapped: nextButtonTapped.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    private let registerNickname = PublishRelay<String>()
    private let nextButtonTapped = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    // Dependency Injection
    private let viewModel: RegisterNicknameViewModel
    
    init?(coder: NSCoder, viewModel: RegisterNicknameViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        bindUI()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nicknameTextField.becomeFirstResponder()
    }
    
    private func bind() {
        output.isEnableNextButton
            .drive(nextButtonView)
            .disposed(by: disposeBag)
        
        output.isEnableNextButton
            .drive(nextButtonLabel)
            .disposed(by: disposeBag)
        
        output.toastMessage
            .emit { [weak self] (message: String) in
                guard let self = self else { return }
                self.view.makeToast(message, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.nextProgress
            .emit { [weak self] (_: Void) in
                guard let self = self else { return }
                let vc: RegisterCategoryViewController = DIContainer.shared.resolve(argument: self.viewModel.registerDataManager)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        nicknameTextField.rx.text
            .compactMap { $0 }
            .bind(to: registerNickname)
            .disposed(by: disposeBag)
        
        nextButtonView.rx.tapGesture()
            .when(.recognized)
            .map { _ in () }
            .bind(to: nextButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareNextButtonView()
        prepareProgressViews()
        prepareNicknameTextField()
    }
    
    private func prepareNextButtonView() {
        nextButtonView.layer.masksToBounds = true
        nextButtonView.layer.cornerRadius = 8
    }
    
    private func prepareNicknameTextField() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: nicknameTextField.frame.height))
        nicknameTextField.leftView = paddingView
        nicknameTextField.leftViewMode = .always
        
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력하세요.", attributes: [
            .foregroundColor: UIColor.linkMoaPlaceholderColor,
            .font: UIFont(name: "NotoSansCJKkr-Regular", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        ])
        
        nicknameTextField.layer.masksToBounds = true
        nicknameTextField.layer.cornerRadius = 8
    }
    
    private func prepareProgressViews() {
        progressView.layer.masksToBounds = true
        progressView.layer.cornerRadius = 2
        currentProgressView.layer.masksToBounds = true
        currentProgressView.layer.cornerRadius = 2
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            nicknameTextFieldBottomLayoutConstraint.constant = keyboardHeight + 15
        }
    }
    
    @IBAction func removeButtonTapped() {
        nicknameTextField.text = ""
        nicknameTextField.sendActions(for: .valueChanged)
    }
}
