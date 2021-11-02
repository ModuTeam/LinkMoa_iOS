//
//  AddFolderCategoryViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/06/29.
//

import Foundation
import LinkMoaCore
import LinkMoaKit

import RxSwift
import RxCocoa
import Moya

final class AddFolderCategoryViewModel: ViewModelType {
    struct Input {
        let fetchCategory: Signal<Void>
        let addFolder: Signal<Void>
        let changeCategory: Signal<Int>
        let changeDetailCategory: Signal<Int>
    }
    
    struct Output {
        let errorMessage: Signal<String>
        let addSucceed: Signal<Void>
        let categoryTitle: Driver<String>
        let detailCategoryTitle: Driver<String>
        let isCategoryNoticeHidden: Driver<Bool>
        let isDetailCategoryNoticeHidden: Driver<Bool>
    }
    
    private let errorMessage = PublishRelay<String> ()
    private let addSucceed = PublishRelay<Void> ()
    private let categoryTitle = BehaviorRelay<String>(value: "")
    private let detailCategoryTitle = BehaviorRelay<String>(value: "")
    private let isCategoryNoticeHidden = BehaviorRelay<Bool>(value: false)
    private let isDetailCategoryNoticeHidden = BehaviorRelay<Bool>(value: false)
    private let disposeBag: DisposeBag = DisposeBag()
    
    var category: Int {
        return dataManager.categoryIdx
    }
    
    // DI
    private let networkProvider: MoyaProvider<LinkMoaAPI>
    private let dataManager: AddFolderDataManager
    private let type: AddFolderType
    
    init(
        networkProvider: MoyaProvider<LinkMoaAPI>,
        dataManager: AddFolderDataManager,
        type: AddFolderType
    ) {
        self.networkProvider = networkProvider
        self.dataManager = dataManager
        self.type = type
    }
    
    func transform(input: Input) -> Output {
        let categoryChanged = PublishRelay<Void>()
        
        Signal.merge([categoryChanged.asSignal(), input.fetchCategory.asSignal()])
            .emit { [weak self] _ in
                guard let self = self else { return }
                let categoryIndex = self.dataManager.categoryIdx
                let detailIndex = self.dataManager.detailCategoryIdx
                
                if let title = Constant.categoryData[categoryIndex] {
                    self.categoryTitle.accept(title)
                    self.isCategoryNoticeHidden.accept(true)
                } else {
                    self.categoryTitle.accept("")
                    self.isCategoryNoticeHidden.accept(false)
                }
    
                if let detailTitle = Constant.detailCategoryData[categoryIndex]?[detailIndex] {
                    self.isDetailCategoryNoticeHidden.accept(true)
                    self.detailCategoryTitle.accept(detailTitle)
                } else {
                    self.isDetailCategoryNoticeHidden.accept(false)
                    self.detailCategoryTitle.accept("")
                }
            }
            .disposed(by: disposeBag)
        
        input.changeCategory
            .distinctUntilChanged()
            .emit { [weak self] index in
                guard let self = self else { return }
                self.dataManager.categoryIdx = index
                self.dataManager.detailCategoryIdx = 0
                categoryChanged.accept(())
            }
            .disposed(by: disposeBag)
        
        input.changeDetailCategory
            .distinctUntilChanged()
            .emit { [weak self] index in
                guard let self = self else { return }
                self.dataManager.detailCategoryIdx = index
                categoryChanged.accept(())
            }
            .disposed(by: disposeBag)
        
        input.addFolder
            .asObservable()
            .filter { [weak self] in // 폴더 추가시에는 카테고리 설정 필요 없음
                guard let self = self else { return true }
                
                if self.dataManager.isShared {
                    if self.dataManager.categoryIdx == 5 {
                        return true
                    }
                    
                    if self.dataManager.categoryIdx == 0 {
                        self.errorMessage.accept("카테고리를 선택해주세요.")
                        return false
                    }
                    
                    
                    if self.dataManager.detailCategoryIdx == 0 {
                        self.errorMessage.accept("상세 카테고리를 선택해주세요.")
                        return false
                    }
                }
                
                return true
            }
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single.error(DefaultError.flatmap) }
                
                var param: [String: Any] = [
                    "folderName": self.dataManager.folderName,
                    "hashTagList": self.dataManager.hashTagList,
                    "folderType": self.dataManager.isShared ? "public" : "private"
                ]
                
                if self.dataManager.categoryIdx == 5 { // 카테고리가 기타 일때
                    param["categoryIdx"] = self.dataManager.categoryIdx
                } else {
                    param["categoryIdx"] = self.dataManager.categoryIdx
                    param["detailCategoryIdx"] = self.dataManager.detailCategoryIdx
                }
                
                switch self.type {
                case .add:
                    return self.networkProvider.rx.request(.addFolder(params: param))
                case .edit:
                    return self.networkProvider.rx.request(
                        .editFolder(index: self.dataManager.index, params: param)
                    )
                }
            }
            .map(FolderResponse.self)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                
                if response.isSuccess == false {
                    self.errorMessage.accept(response.message)
                    return
                }
                
                self.addSucceed.accept(())
            }, onError: { [weak self] _ in
                guard let self = self else { return }
                self.errorMessage.accept("서버 에러가 발생했습니다.")
            })
            .disposed(by: disposeBag)
        
        return Output(
            errorMessage: errorMessage.asSignal(),
            addSucceed: addSucceed.asSignal(),
            categoryTitle: categoryTitle.asDriver(),
            detailCategoryTitle: detailCategoryTitle.asDriver(),
            isCategoryNoticeHidden: isCategoryNoticeHidden.asDriver(),
            isDetailCategoryNoticeHidden: isDetailCategoryNoticeHidden.asDriver()
        )
    }
}
