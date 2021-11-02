//
//  SearchFolderResultViewModel.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/06/10.
//

import Foundation
import LinkMoaCore
import LinkMoaKit

import Moya
import RxCocoa
import RxSwift

final class SearchFolderResultViewModel: ViewModelType {
    struct Input {
        let searchKeyword: Signal<String>
        let searchMore: Signal<Void>
    }
    
    struct Output {
        var results: Driver<[IntegratedFolder]>
        var count: Driver<Int>
        var errorMessage: Signal<String>
    }
    
    private let results = BehaviorRelay<[IntegratedFolder]>(value: [])
    private let count = BehaviorRelay<Int>(value: 0)
    private let errorMessage = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()

    private var pageIndex = 0
    private var keyword = ""
    private var isFetching = false
    private var isMine: Int {
        return type.rawValue
    }
    
    private let networkProvider: MoyaProvider<LinkMoaAPI>
    private let type: SearchType
    
    init(networkProvider: MoyaProvider<LinkMoaAPI>, type: SearchType) {
        self.networkProvider = networkProvider
        self.type = type
    }
    
    func transform(input: Input) -> Output {
        input.searchKeyword.asObservable()
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { [weak self] (keyword: String) in
                guard let self = self else { return false }
                
                if keyword.isEmpty {
                    self.reset()
                }
                
                return !self.isFetching || !keyword.isEmpty
            }
            .flatMap { [weak self] (keyword: String) -> Single<Response> in
                guard let self = self else { return Single<Response>.error(DefaultError.flatmap) }
                self.pageIndex = 0
                
                let param: [String: Any] = [
                    "word": keyword,
                    "page": self.pageIndex,
                    "limit": Constant.pageLimit,
                    "isMyFolders": self.isMine
                ]
                self.keyword = keyword
                return self.networkProvider.rx.request(.searchFolder(params: param))
            }
            .map(SearchFolder.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else {
                    self.errorMessage.accept("서버 요청이 실패했습니다.")
                    self.isFetching = false
                    return
                }
                
                if let result = response.result {
                    self.results.accept(result)
                    self.count.accept(response.resultCount)
                    self.isFetching = false
                    self.pageIndex += 1
                } else {
                    self.errorMessage.accept("서버 요청이 실패했습니다.")
                }
                
                self.isFetching = false
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.errorMessage.accept(error.localizedDescription)
                self.isFetching = false
            })
            .disposed(by: disposeBag)
        
        input.searchMore
            .asObservable()
            .filter { [weak self] _ in
                guard let self = self else { return false }
                return !self.isFetching
            }
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(DefaultError.flatmap) }
                
                let param: [String: Any] = [
                    "word": self.keyword,
                    "page": self.pageIndex,
                    "limit": Constant.pageLimit,
                    "isMyFolders": self.isMine
                ]
                return self.networkProvider.rx.request(.searchFolder(params: param))
            }
            .map(SearchFolder.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else {
                    self.errorMessage.accept("서버 요청이 실패했습니다.")
                    self.isFetching = false
                    return
                }
                
                if let result = response.result {
                    self.results.accept(self.results.value + result)
                    self.isFetching = false
                    self.pageIndex += (result.count > 0 ? 1 : 0)
                } else {
                    self.errorMessage.accept("서버 요청이 실패했습니다.")
                }
                
                self.isFetching = false
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.errorMessage.accept(error.localizedDescription)
                self.isFetching = false
            })
            .disposed(by: disposeBag)
        
        return Output(
            results: results.asDriver(),
            count: count.asDriver(),
            errorMessage: errorMessage.asSignal()
        )
    }

    private func reset() {
        self.count.accept(0)
        self.results.accept([])
        pageIndex = 0
        keyword = ""
    }
}
