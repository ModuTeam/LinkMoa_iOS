//
//  CategoryViewModel.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/05/28.
//

import Foundation
import LinkMoaCore
import LinkMoaKit

import Moya
import RxCocoa
import RxSwift

final class SurfingCategoryViewModel: ViewModelType {
    struct Input {
        let fetchFolders: Signal<Void>
        let resetFolders: Signal<Void>
        let fetchCategory: Signal<Void>
        let changeSubIndex: Signal<Int>
    }
    
    struct Output {
        var categoryDetailFolders: Driver<[IntegratedFolder]>
        var categories: Driver<[CategoryInfo.DetailCategoryList]>
        var toastMessage: Signal<String>
        var isHiddenNoticeView: Driver<Bool>
    }
    
    private let toastMessage = PublishRelay<String>()
    private let isHiddenNoticeView = BehaviorRelay<Bool>(value: true)
    private let disposeBag = DisposeBag()
    
    private var lastFolderIndex: Int = 0
    private var folderSubIndex: Int = 0
    private var isFetching: Bool = false
    private var isEnd: Bool = false
    
    // DI
    private let networkProvider: MoyaProvider<LinkMoaAPI>
    private let folderMainIndex: Int

    init(
        networkProvider: MoyaProvider<LinkMoaAPI>,
        folderMainIndex: Int
    ) {
        self.networkProvider = networkProvider
        self.folderMainIndex = folderMainIndex + 1
    }
    
    func transform(input: Input) -> Output {
        let folders: BehaviorRelay<[IntegratedFolder]> = .init(value: [])
        
        input.fetchFolders
            .asObservable()
            .filter { [weak self] _ in
                guard let self = self else { return false }
                return !self.isFetching && !self.isEnd
            }
            .flatMap { [weak self] target -> Driver<[IntegratedFolder]> in
                guard let self = self else { return Driver.just([]) }
                self.isFetching = true
                return self.fetchCategoryDetailFolder()
            }
            .do { [weak self] folders in
                guard let self = self else { return }
                self.isFetching = false
                
                if let lastFolder = folders.last {
                    self.lastFolderIndex = lastFolder.folderIndex
                }
                
                self.isHiddenNoticeView.accept(!folders.isEmpty)
                self.isEnd = folders.count < Constant.pageLimit
            }
            .subscribe { folders.accept(folders.value + $0) }
            .disposed(by: disposeBag)
        
        input.resetFolders
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.reset()
                folders.accept([])
            })
            .disposed(by: disposeBag)
        
        let categories = input.fetchCategory
            .flatMap { [weak self] _ -> Driver<[CategoryInfo.DetailCategoryList]> in
                guard let self = self else { return Driver.just([]) }
                return self.fetchCategories()
            }
        
        input.changeSubIndex
            .asObservable()
            .distinctUntilChanged()
            .subscribe { [weak self] (subIndex: Int) in
                guard let self = self else { return }
                self.folderSubIndex = subIndex
                self.reset()
                folders.accept([])
            }
            .disposed(by: disposeBag)
        
        return Output(
            categoryDetailFolders: folders.asDriver(),
            categories: categories,
            toastMessage: toastMessage.asSignal(),
            isHiddenNoticeView: isHiddenNoticeView.asDriver()
        )
    }
    
    private func reset() {
        lastFolderIndex = 0
        isEnd = false
    }
}

extension SurfingCategoryViewModel { 
    private func fetchCategoryDetailFolder() -> Driver<[IntegratedFolder]> {
        let params: [String: Any] = [
            "limit": Constant.pageLimit,
            "lastFolderIdx": self.lastFolderIndex
        ]
        
        let api = LinkMoaAPI.categoryDetail(
            mainIndex: self.folderMainIndex,
            subIndex: self.folderSubIndex,
            params: params
        )
        
        return self.networkProvider.rx.request(api)
            .map(CategoryDetailFolder.self)
            .map { [weak self] response in
                guard let self = self else { return [] }
                if response.isSuccess, let result = response.result {
                    return result.list
                } else {
                    self.toastMessage.accept(response.message)
                    return []
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    private func fetchCategories() -> Driver<[CategoryInfo.DetailCategoryList]> {
        return self.networkProvider.rx.request(.categories)
            .map(CategoryInfo.self)
            .map { [weak self] response in
                guard let self = self else { return [] }
                if response.isSuccess, let result = response.result {
                    var categories: [CategoryInfo.DetailCategoryList] = []
                    categories.append(.init(detailIndex: 0, detailName: "전체"))
                    categories.append(contentsOf: result[self.folderMainIndex - 1].detailList)
                    return categories
                } else {
                    self.toastMessage.accept(response.message)
                    return []
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
}
