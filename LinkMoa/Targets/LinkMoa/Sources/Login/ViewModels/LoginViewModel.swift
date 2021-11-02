//
//  LoginViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/11.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation
import LinkMoaCore
import LinkMoaKit

import RxSwift
import RxCocoa
import Moya

enum LoginFlow {
    case home
    case register
}

final class LoginViewModel: ViewModelType {
    struct Input {
        let appleLogin: Signal<String>
        let googleLogin: Signal<String>
    }
    
    struct Output {
        let nextProgress: Signal<LoginFlow>
        let toastMessage: Signal<String>
    }

    private let nextProgress = PublishRelay<LoginFlow>()
    private let toastMessage = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    // Dependcy Injection
    private let linkMoaProvider: MoyaProvider<LinkMoaAPI>
    private let loginProvider: MoyaProvider<LoginAPI>
    private let tokenManager: TokenManager
    
    init(
        linkMoaProvider: MoyaProvider<LinkMoaAPI>,
        loginProvider: MoyaProvider<LoginAPI>,
        tokenManager: TokenManager
    ) {
        self.linkMoaProvider = linkMoaProvider
        self.loginProvider = loginProvider
        self.tokenManager = tokenManager
    }
    
    func transform(input: Input) -> Output {
        let appleLogin = input.appleLogin.asObservable()
            .flatMap { [weak self] authCode -> Single<Response> in
                print(authCode)
                
                guard let self = self else {
                    return Single<Response>.error(DefaultError.flatmap)
                }
                    
                return self.loginProvider.rx.request(.appleLogin(authCode: authCode))
            }
        
        let googleLogin = input.googleLogin.asObservable()
            .flatMap { [weak self] accessToken -> Single<Response> in
                guard let self = self else {
                    return Single<Response>.error(DefaultError.flatmap)
                }
                    
                return self.loginProvider.rx.request(.googleLogin(accessToken: accessToken))
            }
        
        Observable.merge([appleLogin, googleLogin])
            .map(SocialLogin.self)
            .do { [weak self] response in
                guard let self = self else { return }
                print(response)
                if let result = response.result {
                    self.tokenManager.jwt = result.jwt
                }
            }
            .flatMapLatest { [weak self] authCode -> Single<Response> in
                guard let self = self else {
                    return Single<Response>.error(DefaultError.flatmap)
                }
                    
                return self.linkMoaProvider.rx.request(.userInformation)
            }
            .map(UserInformation.self)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }

                // [홈 화면] -> 회원, 정보까지 입력된 상태
                if let info = response.result?.first, info.categoryIndex != -1 {
                    self.nextProgress.accept(.home)
                } else { // [회원가입 화면] -> 회원이지만, 정보 입력이 필요한 상태
                    self.nextProgress.accept(.register)
                }

            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.toastMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
            
        return Output(
            nextProgress: nextProgress.asSignal(),
            toastMessage: toastMessage.asSignal()
        )
    }
}
