//
//  SurfingViewModel.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/06/08.
//

import Foundation
import LinkMoaCore
import LinkMoaKit

import Moya
import RxCocoa
import RxSwift

final class SurfingViewModel: ViewModelType {
    struct Input {
        let fetchTopTenFolders: Signal<Void>
        let fetchLikedFolders: Signal<Void>
    }
    
    struct Output {
        var sections: Driver<[SurfingSectionModel]>
        var errorMessage: Signal<String>
    }
    
    private let errorMessage: PublishRelay<String> = PublishRelay()
    private let disposeBag = DisposeBag()

    // Dependency Injection
    private let networkProvider: MoyaProvider<LinkMoaAPI>
    
    init(networkProvider: MoyaProvider<LinkMoaAPI>) {
        self.networkProvider = networkProvider
    }
    
    func transform(input: Input) -> Output {
        let sections: BehaviorRelay<[SurfingSectionModel]> = BehaviorRelay(value: [
            .topTenSection(items: .init(repeating: .topTenItem(folder: .init()), count: 4)),
            .categorySection(items: Array(0...4).map {.categoryItem(index: $0)}),
            .likedSection(items: [])
        ])
        
        let topTen = input.fetchTopTenFolders
            .flatMap { [weak self] _ -> Driver<[IntegratedFolder]> in
                guard let self = self else { return Driver.just([]) }
                return self.fetchTopTenFolders()
            }
            .asDriver()

        let liked = input.fetchLikedFolders
            .flatMap { [weak self] _ -> Driver<[IntegratedFolder]> in
                guard let self = self else { return Driver.just([]) }
                return self.fetchLikedFolders()
            }
            .asDriver()
        
        Driver.zip(topTen, liked)
            .drive(onNext: { topTen, liked in
                if liked.isEmpty {
                    sections.accept([
                        .topTenSection(items: topTen.map { .topTenItem(folder: $0) }),
                        .categorySection(items: Array(0...4).map {.categoryItem(index: $0) }),
                        .likedSection(items: liked.map { .likedItem(folder: $0) }),
                        .likedFooterSection(items: [])
                    ])
                } else {
                    sections.accept([
                        .topTenSection(items: topTen.map { .topTenItem(folder: $0) }),
                        .categorySection(items: Array(0...4).map {.categoryItem(index: $0)}),
                        .likedSection(items: liked.map { .likedItem(folder: $0) })
                    ])
                }
            })
            .disposed(by: disposeBag)
        
        return Output(sections: sections.asDriver(), errorMessage: errorMessage.asSignal())
    }
}

extension SurfingViewModel {
    private func fetchTopTenFolders() -> Driver<[IntegratedFolder]> {
        return self.networkProvider.rx.request(.topTenFolder)
            .map(TopTenFolder.self)
            .map { [weak self] response in
                guard let self = self else { return [] }
                if response.isSuccess {
                    return Array(response.result.prefix(4))
                } else {
                    self.errorMessage.accept(response.message)
                    return []
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    private func fetchLikedFolders() -> Driver<[IntegratedFolder]> {
        let params: [String: Any] = ["page": 0, "limit": 4]
        
        return self.networkProvider.rx.request(.likedFolder(params: params))
            .map(LikedFolder.self)
            .map { [weak self] response in
                guard let self = self else { return [] }
                guard response.isSuccess else {
                    self.errorMessage.accept(response.message)
                    return []
                }
                
                if let result = response.result {
                    return result
                } else {
                    return []
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
}
