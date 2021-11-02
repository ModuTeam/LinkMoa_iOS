//
//  FolderDetailViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/11.
//

import Foundation
import LinkMoaCore
import LinkMoaKit

import RxSwift
import RxCocoa
import Moya

final class FolderDetailViewModel: ViewModelType {
    struct Input {
        let fetchFolder: Signal<Void>
        let removeLink: Signal<Int>
    }
    
    struct Output {
        let errorMessage: Signal<String>
        let bottomAlert: Signal<Void>
        let isLoading: Driver<Bool>
        let sections: Driver<[LinkSectionData]>
        let folderName: Driver<String>
        let tags: Driver<[String]>
        let isShared: Driver<Bool>
        let linksCount: Driver<Int>
        let isEmptyFolder: Driver<Bool>
    }
    
    // Event
    private let errorMessage = PublishRelay<String>()
    private let bottomAlert = PublishRelay<Void>()
    
    // State
    private let isLoading = BehaviorRelay<Bool>(value: false)
    private let sections = BehaviorRelay<[LinkSectionData]>(value: [])
    private let folderName = BehaviorRelay<String>(value: "")
    private let tags = BehaviorRelay<[String]>(value: [])
    private let isShared = BehaviorRelay<Bool>(value: false)
    private let linksCount = BehaviorRelay<Int>(value: 0)
    private let isEmptyFolder = BehaviorRelay<Bool>(value: false)
    private let _folder = BehaviorRelay<FolderDetail.Result>(value: .init())
    private let disposeBag = DisposeBag()
    
    var links: [FolderDetail.Link] = []
    
    var folder: FolderDetail.Result {
        return _folder.value
    }
    
    var shareItem: String {
        let links = self.links.map { "\($0.name)\n\($0.url)\n\n" }.joined()
        return self.folderName.value + "\n\n" + links
    }
    
    var removeFolderName: String {
        return self.folderName.value
    }
    
    private let networkProvider: MoyaProvider<LinkMoaAPI>
    let folderIndex: Int

    // Dependency Injection
    init(networkProvider: MoyaProvider<LinkMoaAPI>, folderIndex: Int) {
        self.networkProvider = networkProvider
        self.folderIndex = folderIndex
    }

    func transform(input: Input) -> Output {
        var removeIndex: Int?
        
        input.fetchFolder.asObservable()
            .do { [weak self] _ in
                guard let self = self else { return }
                self.isLoading.accept(true)
            }
            .flatMap { [weak self] index -> Single<Response> in
                guard let self = self else { return Single.error(DefaultError.flatmap) }
                return self.networkProvider.rx.request(.folderDetail(index: self.folderIndex))
            }
            .map(FolderDetail.self)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                
                if response.isSuccess == false {
                    self.errorMessage.accept(response.message)
                    return
                }
                
                if let folder = response.result {
                    self._folder.accept(folder)
                    self.sections.accept([.init(items: folder.linkList, uniqueID: 0)])
                    self.links = folder.linkList
                    self.isEmptyFolder.accept(self.links.isEmpty)
                    self.folderName.accept(folder.name)
                    self.tags.accept(folder.hashTagList.map { $0.name })
                    self.isShared.accept(folder.type == "public" ? true : false)
                    self.linksCount.accept(folder.linkCount)
                }
                
                self.isLoading.accept(false)
                
            }, onError: { [weak self] _ in
                guard let self = self else { return }
                self.errorMessage.accept("서버 에러가 발생했습니다.")
            })
            .disposed(by: disposeBag)
        
        input.removeLink.asObservable() // 링크 삭제 성공하면 다시 전체 fetch 하지 않도록
            .do { [weak self] index in
                self?.isLoading.accept(true)
                removeIndex = index
            }
            .flatMap { [weak self] index -> Single<Response> in
                guard let self = self else { return Single.error(DefaultError.flatmap) }
                return self.networkProvider.rx.request(.deleteLink(index: index))
            }
            .map(FolderResponse.self)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.isSuccess == false {
                    self.errorMessage.accept(response.message)
                    return
                }
                self.links = self.links.filter({ $0.index != removeIndex })
                self.isEmptyFolder.accept(self.links.isEmpty)
                self.isLoading.accept(false)
                self.sections.accept([.init(items: self.links, uniqueID: 0)])
                self.linksCount.accept(self.links.count)
                self.bottomAlert.accept(())
            }, onError: { [weak self] _ in
                guard let self = self else { return }
                self.errorMessage.accept("서버 에러가 발생했습니다.")
            })
            .disposed(by: disposeBag)
        
        return Output(
            errorMessage: errorMessage.asSignal(),
            bottomAlert: bottomAlert.asSignal(),
            isLoading: isLoading.asDriver(),
            sections: sections.asDriver(),
            folderName: folderName.asDriver(),
            tags: tags.asDriver(),
            isShared: isShared.asDriver(),
            linksCount: linksCount.asDriver(),
            isEmptyFolder: isEmptyFolder.asDriver()
        )
    }
}
