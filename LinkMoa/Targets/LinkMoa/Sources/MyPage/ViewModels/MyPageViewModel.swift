//
//  RxMyPageViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/05/19.
//

import Foundation
import LinkMoaCore
import LinkMoaKit

import RxSwift
import RxCocoa
import Moya

final class MyPageViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let fetchUserNickname: Signal<Void>
        let useSafariToggle: Signal<Bool>
        let changeUserNickName: Signal<String>
        let logout: Signal<Void>
        let deleteUser: Signal<Void>
    }
    
    struct Output {
        let bottomAlert: Signal<Void>
        let toastMessage: Signal<String>
        let userNickName: Driver<String>
        let settingMenus: Driver<[String]>
        let isUseSafari: Driver<Bool>
        let isLoading: Driver<Bool>
    }
        
    // MARK: - Output Relays
    private let bottomAlert = PublishRelay<Void>()
    private let toastMessage = PublishRelay<String>()
    private let userNickName = BehaviorRelay<String>(value: " ")
    private let settingMenus = BehaviorRelay<[String]>(
        value: ["FAQ", "건의&불편신고", "링크모아 브라우저 사용하기", "버전 정보", "오픈소스 라이센스 이용고지", "탈퇴하기"]
    )
    private let isUseSafari = BehaviorRelay<Bool>(value: false)
    private let isLoading = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()

    // Trigger
    private let succeedChangeNickname = PublishRelay<Void>()
    
    // MARK: - Public Variables
    var nickName: String {
        return self.userNickName.value
    }
    
    private var id: Int = 0
    
    // Dependency Injection
    private let networkProvider: MoyaProvider<LinkMoaAPI>
    private var tokenManager: TokenManager
    
    init(networkProvider: MoyaProvider<LinkMoaAPI>, tokenManager: TokenManager) {
        self.networkProvider = networkProvider
        self.tokenManager = tokenManager
    }
    
    func transform(input: Input) -> Output {
        Signal.merge([input.fetchUserNickname, succeedChangeNickname.asSignal()])
            .asObservable()
            .do { [weak self] _ in
                guard let self = self else { return }
                self.isLoading.accept(true)
            }
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single.error(DefaultError.flatmap) }
                return self.networkProvider.rx.request(.userInformation)
            }
            .map(UserInformation.self)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                
                if response.isSuccess == false {
                    self.toastMessage.accept(response.message)
                    return
                }
                
                if let user = response.result?.first {
                    self.userNickName.accept(user.nickname)
                    self.id = user.index
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.toastMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)

        input.changeUserNickName
            .asObservable()
            .do { [weak self] _ in
                guard let self = self else { return }
                self.isLoading.accept(true)
            }
            .flatMap { [weak self] nickname -> Single<Response> in
                guard let self = self else { return Single.error(DefaultError.flatmap) }
                return self.networkProvider.rx.request(.editUserInformation(params: ["userNickname": nickname]))
            }
            .map(FolderResponse.self)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                
                if response.isSuccess == false {
                    self.toastMessage.accept(response.message)
                    return
                }
                
                self.isLoading.accept(false)
                self.succeedChangeNickname.accept(())
                self.bottomAlert.accept(())
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.toastMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        input.deleteUser
            .asObservable()
            .do { [weak self] _ in
                guard let self = self else { return }
                self.isLoading.accept(true)
            }
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single.error(DefaultError.flatmap) }
                return self.networkProvider.rx.request(.deleteAccount(index: self.id))
            }
            .map(FolderResponse.self)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                
                if response.isSuccess == false {
                    self.toastMessage.accept(response.message)
                    return
                }
                
                self.isLoading.accept(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.toastMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        input.useSafariToggle
            .emit { isUsingCustomBrowser in
                self.tokenManager.isUsingCustomBrowser = isUsingCustomBrowser
            }
            .disposed(by: disposeBag)
        
        input.logout
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.tokenManager.jwt = nil
            }
            .disposed(by: disposeBag)
        
        // 초기값 설정
        isUseSafari.accept(tokenManager.isUsingCustomBrowser ?? false)
        
        return Output(
            bottomAlert: bottomAlert.asSignal(),
            toastMessage: toastMessage.asSignal(),
            userNickName: userNickName.asDriver(),
            settingMenus: settingMenus.asDriver(),
            isUseSafari: isUseSafari.asDriver(),
            isLoading: isLoading.asDriver()
        )
    }
}
