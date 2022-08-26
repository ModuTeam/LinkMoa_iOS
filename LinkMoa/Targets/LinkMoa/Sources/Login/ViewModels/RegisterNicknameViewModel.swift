//
//  RegisterNicknameViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/12.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation
import LinkMoaCore
import LinkMoaKit

import RxSwift
import RxCocoa
import Moya

final class RegisterNicknameViewModel: ViewModelType {
    struct Input {
        let registerNickname: Signal<String>
        let nextButtonTapped: Signal<Void>
    }
    
    struct Output {
        let toastMessage: Signal<String>
        let nextProgress: Signal<Void>
        let isEnableNextButton: Driver<Bool>
    }
    
    private let toastMessage = PublishRelay<String>()
    private let nextProgress = PublishRelay<Void>()
    private let isEnableNextButton = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    // Dependcy Injection
    private let linkMoaProvider: MoyaProvider<LinkMoaAPI>
    let registerDataManager: RegisterDataManager
    
    init(linkMoaProvider: MoyaProvider<LinkMoaAPI>, registerDataManager: RegisterDataManager) {
        self.linkMoaProvider = linkMoaProvider
        self.registerDataManager = registerDataManager
    }
    
    func transform(input: Input) -> Output {
        input.registerNickname
            .emit { [weak self] (nickname: String) in
                guard let self = self else { return }
                self.registerDataManager.nickname = nickname
                self.isEnableNextButton.accept(!nickname.isEmpty)
            }
            .disposed(by: disposeBag)
        
        input.nextButtonTapped.asObservable()
            .filter { [weak self] _ in
                guard let self = self else { return false }
                guard self.isEnableNextButton.value else { return false }
                let nickname = self.registerDataManager.trimmedNickname

                guard nickname.isEmpty == false else {
                    self.toastMessage.accept("닉네임을 입력해주세요.")
                    return false
                }

                return true
            }
            .flatMap { [weak self] _ -> Single<Response> in
                guard let self = self else {
                    return Single<Response>.error(DefaultError.flatmap)
                }

                let nickname = self.registerDataManager.nickname
                let api = LinkMoaAPI.editUserInformation(params: ["userNickname": nickname])
                return self.linkMoaProvider.rx.request(api)
            }
            .map(EditUserInformationResponse.self)
            .catchError { error in
              self.toastMessage.accept(error.localizedDescription)
              return .never()
            }
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }

                if response.isSuccess, response.code == 1000 {
                  self.nextProgress.accept(())
                } else {
                  self.toastMessage.accept(response.message)
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.toastMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        return Output(
            toastMessage: toastMessage.asSignal(),
            nextProgress: nextProgress.asSignal(),
            isEnableNextButton: isEnableNextButton.asDriver()
        )
    }
}
