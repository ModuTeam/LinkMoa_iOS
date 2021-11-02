//
//  RegisterViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/19.
//

import Foundation
import LinkMoaCore
import LinkMoaKit

import RxSwift
import RxCocoa
import Moya

enum RegisterFlow {
    case complete
}

typealias DetailCategory = (name: String, index: Int)

final class RegisterDetailCategoryViewModel: ViewModelType {
    struct Input {
        let selectDetailCategory: Signal<Int>
        let nextButtonTapped: Signal<Void>
    }
    
    struct Output {
        let categories: Driver<[DetailCategory]>
        let isEnableNextButton: Driver<Bool>
        let nextProgress: Signal<RegisterFlow>
        let toastMessage: Signal<String>
    }
    
    private let categories = BehaviorRelay<[DetailCategory]>(value: [])
    private let isEnableNextButton = BehaviorRelay<Bool>(value: false)
    private let nextProgress = PublishRelay<RegisterFlow>()
    private let toastMessage = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    // Dependcy Injection
    private let linkMoaProvider: MoyaProvider<LinkMoaAPI>
    private let registerDataManager: RegisterDataManager

    init(linkMoaProvider: MoyaProvider<LinkMoaAPI>, registerDataManager: RegisterDataManager) {
        self.linkMoaProvider = linkMoaProvider
        self.registerDataManager = registerDataManager
    }
    
    func transform(input: Input) -> Output {
        let whenCategoryNumberIsFive = PublishRelay<Void>()
        
        Observable.merge([
                whenCategoryNumberIsFive.asObservable(),
                input.nextButtonTapped.asObservable()
            ])
            .filter { [weak self] _ -> Bool in
                guard let self = self else { return false }
                // 카테고리가 기타인 경우 바로 완료처리
                if self.registerDataManager.categoryIndex == 5 {
                    return true
                }
                return self.isEnableNextButton.value
            }
            .flatMap { [weak self] _ -> Single<Response> in
                guard let self = self else {
                    return Single<Response>.error(DefaultError.flatmap)
                }

                var params: [String: Any] = [
                    "userNickname": self.registerDataManager.nickname,
                    "userCategoryIdx": self.registerDataManager.categoryIndex
                ]
                
                if self.registerDataManager.detailCategoryIndex != -1 {
                    params["userDetailCategoryIdx"] = self.registerDataManager.detailCategoryIndex
                }
                
                let api = LinkMoaAPI.editUserInformation(params: params)
                return self.linkMoaProvider.rx.request(api)
            }
            .map(EditUserInformationResponse.self)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                
                guard response.isSuccess else {
                    self.toastMessage.accept("요청에 실패했습니다.")
                    return
                }
                
                self.nextProgress.accept(.complete)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.toastMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        input.selectDetailCategory
            .emit { [weak self] (index: Int) in
                guard let self = self else { return }
                self.registerDataManager.detailCategoryIndex = index
                self.isEnableNextButton.accept(true)
            }
            .disposed(by: disposeBag)
        
        // 카테고리가 기타인 경우 바로 완료처리
        if registerDataManager.categoryIndex == 5 {
            whenCategoryNumberIsFive.accept(())
        }
        
        if let category = Constant.detailCategoryData[registerDataManager.categoryIndex] {
            let details = category.map { DetailCategory(name: $0.value, index: $0.key) }
            categories.accept(details)
        }
        
        return Output(
            categories: categories.asDriver(),
            isEnableNextButton: isEnableNextButton.asDriver(),
            nextProgress: nextProgress.asSignal(),
            toastMessage: toastMessage.asSignal()
        )
    }
}
