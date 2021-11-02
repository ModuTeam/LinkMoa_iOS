//
//  SurfingFolderViewModel.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/05/27.
//

import Foundation
import LinkMoaCore
import LinkMoaKit

import Moya
import RxCocoa
import RxSwift

final class SurfingFolderViewModel: ViewModelType {
    struct Input {
        let fetchFolder: Signal<Void>
    }
    
    struct Output {
        let folders: Driver<[IntegratedFolder]>
        let folderCount: Driver<Int>
        let title: Driver<String>
        let isHiddenNoticeView: Driver<Bool>
        let isHiddenCountLabel: Driver<Bool>
        let toastMessage: Signal<String>
    }
    
    private let toastMessage = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    private let networkManager: MoyaProvider<LinkMoaAPI>
    private let type: SurfingFolderType
    
    init(networkManager: MoyaProvider<LinkMoaAPI>, type: SurfingFolderType) {
        self.networkManager = networkManager
        self.type = type
    }
    
    func transform(input: Input) -> Output {
        let folders = BehaviorRelay<[IntegratedFolder]>(value: [])
        let folderCount = BehaviorRelay<Int>(value: 0)
        let title = BehaviorRelay<String>(value: "")
        let isHiddenNoticeView = BehaviorRelay<Bool>(value: true)
        let isHiddenCountLabel = BehaviorRelay<Bool>(value: true)
        
        input.fetchFolder
            .flatMap { [weak self] _ -> Driver<[IntegratedFolder]> in
                guard let self = self else { return Driver.just([]) }
                switch self.type {
                case .liked:
                    return self.fetchLikedFolders()
                case .topTen:
                    return self.fetchTopTenFolder()
                case .users(_, let index):
                    return self.fetchUsersFolders(user: index)
                }
            }
            .do { folders in
                isHiddenNoticeView.accept(!folders.isEmpty)
                folderCount.accept(folders.count)
            }
            .drive { folders.accept($0) }
            .disposed(by: disposeBag)
        
        title.accept(type.title)
        
        if case .users(_, _) = type {
            isHiddenCountLabel.accept(false)
        }
        
        return Output(
            folders: folders.asDriver(),
            folderCount: folderCount.asDriver(),
            title: title.asDriver(),
            isHiddenNoticeView: isHiddenNoticeView.asDriver(),
            isHiddenCountLabel: isHiddenCountLabel.asDriver(),
            toastMessage: toastMessage.asSignal()
        )
    }
}

extension SurfingFolderViewModel {
    private func fetchTopTenFolder() -> Driver<[IntegratedFolder]> {
        return self.networkManager.rx.request(.topTenFolder)
            .map(TopTenFolder.self)
            .map { [weak self] response in
                guard let self = self else { return [] }
                if response.isSuccess {
                    return response.result
                } else {
                    self.toastMessage.accept(response.message)
                    return []
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    private func fetchLikedFolders(word: String? = nil, page: Int = 0) -> Driver<[IntegratedFolder]> {
        var params: [String: Any] = ["page": page, "limit": 200]
        
        // 찜한 링크달 검색을 위해 만들어 놓았으나 아직 사용안함.
        if let word = word {
            params["word"] = word
        }
        return self.networkManager.rx.request(.likedFolder(params: params))
            .map(LikedFolder.self)
            .map { [weak self] response in
                guard let self = self else { return [] }
                
                guard response.isSuccess else {
                    self.toastMessage.accept(response.message)
                    return []
                }
                
                if let result = response.result {
                    return result
                }
                
                return []
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    private func fetchUsersFolders(user: Int, page: Int = 0) -> Driver<[IntegratedFolder]> {
        let params: [String: Any] = ["page": page, "limit": 100]
        
        return self.networkManager.rx.request(.usersFolder(index: user, params: params))
            .map(UsersFolder.self)
            .map { [weak self] response in
                guard let self = self else { return [] }
                if response.isSuccess, let result = response.result  {
                    return result
                } else {
                    self.toastMessage.accept(response.message)
                    return []
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
}
