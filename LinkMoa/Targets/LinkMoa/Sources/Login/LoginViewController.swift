//
//  LoginViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/08.
//

import AuthenticationServices
import LinkMoaBottomSheet
import LinkMoaCore
import LinkMoaKit
import UIKit
import SafariServices

import GoogleSignIn
import Lottie
import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import Toast_Swift

final class LoginViewController: UIViewController {
    @IBOutlet private weak var googleLoginButtonView: UIView!
    @IBOutlet private weak var appleLoginStackView: UIStackView!
    @IBOutlet private weak var animationBaseView: UIView!
    @IBOutlet private weak var privateRuleLabel: UILabel!
    @IBOutlet private weak var useRuleLabel: UILabel!
    
    private lazy var animationView: AnimationView = {
        let animationView = AnimationView(name: "garibi")
        animationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 375)
        animationView.loopMode = .loop
        return animationView
    }()
        
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private lazy var input = LoginViewModel.Input(
        appleLogin: appleLogin.asSignal(),
        googleLogin: googleLogin.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)

    private let appleLogin = PublishRelay<String>()
    private let googleLogin = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    // Dependency Injection
    private let viewModel: LoginViewModel
    
    init?(coder: NSCoder, viewModel: LoginViewModel) {
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(restartAnimation),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }
    
    private func bind() {
        output.nextProgress
            .emit { [weak self] (type: LoginFlow) in
                guard let self = self else { return }

                switch type {
                case .home:
                    self.moveHomeVC()
                case .register:
                    self.moveRegisterVC()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareAppleLoginStackView()
        prepareGoogleLoginView()
        prepareRuleLabels()
        prepareAnimationView()
    }
    
    private func prepareAppleLoginStackView() {
        let button = ASAuthorizationAppleIDButton(
            authorizationButtonType: .signIn,
            authorizationButtonStyle: .white
        )
        appleLoginStackView.addArrangedSubview(button)
        appleLoginStackView.layer.masksToBounds = true
        appleLoginStackView.layer.cornerRadius = 8
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(appleLoginStackViewTapped))
        appleLoginStackView.addGestureRecognizer(tapGesture)
        appleLoginStackView.isUserInteractionEnabled = true
    }
    
    private func prepareRuleLabels() {
        let privateTapGesture = UITapGestureRecognizer(target: self, action: #selector(ruleLabelsTapped(_:)))
        privateRuleLabel.addGestureRecognizer(privateTapGesture)
        privateRuleLabel.isUserInteractionEnabled = true
        
        let privateAttributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let privateUnderlineAttributedString = NSAttributedString(
            string: "개인정보처리방침",
            attributes: privateAttributes
        )
        privateRuleLabel.attributedText = privateUnderlineAttributedString
        
        let useTapGesture = UITapGestureRecognizer(target: self, action: #selector(ruleLabelsTapped(_:)))
        useRuleLabel.addGestureRecognizer(useTapGesture)
        useRuleLabel.isUserInteractionEnabled = true
        
        let useAttributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let useUnderlineAttributedString = NSAttributedString(
            string: "이용약관",
            attributes: useAttributes
        )
        useRuleLabel.attributedText = useUnderlineAttributedString
    }
    
    private func prepareAnimationView() {
        animationBaseView.addSubview(animationView)
    }
    
    private func prepareGoogleLoginView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startButtonTapped))
        googleLoginButtonView.addGestureRecognizer(tapGesture)
        googleLoginButtonView.isUserInteractionEnabled = true
        googleLoginButtonView.layer.masksToBounds = true
        googleLoginButtonView.layer.cornerRadius = 8
    }
    
    @objc private func restartAnimation() {
        animationView.play()
    }
    
    @objc private func appleLoginStackViewTapped() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self as ASAuthorizationControllerDelegate
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
    @objc private func ruleLabelsTapped(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        
        switch tag {
        case 1:
            if let url = URL(string: "https://www.notion.so/f87acd8339a8480cb79e0c4b06a6cc7e") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true)
            }
        case 2:
            if let url = URL(string: "https://www.notion.so/f87acd8339a8480cb79e0c4b06a6cc7e") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true)
            }
        default:
            break
        }
    }
}

// MARK:- Coordinate
extension LoginViewController {
    private func moveHomeVC() {
        let window: UIWindow = DIContainer.shared.resolve()
        let homeNC: HomeNavigationController = DIContainer.shared.resolve()
        
        window.rootViewController = homeNC
        window.makeKeyAndVisible()
        UIView.transition(
            with: window,
            duration: 0.1,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
    }
    
    private func moveRegisterVC() {
        let window: UIWindow = DIContainer.shared.resolve()
        let registerNC: RegisterNavigationController = DIContainer.shared.resolve()
        
        window.rootViewController = registerNC
        window.makeKeyAndVisible()
        UIView.transition(
            with: window,
            duration: 0.1,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
    }
}

// MARK:- Apple Login
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {}
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let authorizationCodeData = credential.authorizationCode,
              let authorizationCode = String(data: authorizationCodeData, encoding: .utf8)
        else {
            return
        }
        
        appleLogin.accept(authorizationCode)
    }
}

// MARK:- Google Sign
extension LoginViewController {
    @objc private func startButtonTapped() {
        let signInConfig = GoogleSign.shared.signInConfig
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { [weak self] user, error in
            guard let self = self else { return }
            if let _ = error {
                return
            }
            
            guard let accessToken = user?.authentication.accessToken else {
                return
            }
            
            self.googleLogin.accept(accessToken)
        }
    }
}
