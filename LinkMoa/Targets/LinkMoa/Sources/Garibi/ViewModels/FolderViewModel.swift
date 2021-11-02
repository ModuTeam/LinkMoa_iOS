//
//  FolderViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/07.
//

import Foundation
import LinkMoaCore
import LinkMoaKit

import RxSwift
import RxCocoa
import Moya

enum FolderFetchType: Int, CaseIterable {
    case current = 1 // 최신 순
    case name = 2 // 이름 순
    case old = 3 // 오래된 순
    
    var title: String {
        switch self {
        case .current:
            return "최신 순"
        case .name:
            return "이름 순"
        case .old:
            return "생성 순"
        }
    }
}

final class FolderViewModel: ViewModelType {
    struct Input {
        let fetchFolders: Signal<Void>
        let folderShareTapped: Signal<Int>
        let fetchFolderOrder: Signal<FolderFetchType>
        let removeFolder: Signal<Int>
    }
    
    struct Output {
        /// EVENT
        let toastMessage: Signal<String>
        let removeBottomAlert: Signal<Void>
        let folderShareSheet: Signal<String>
        /// STATE
        let sections: Driver<[FolderSectionData]>
        let isLoading: Driver<Bool>
        let isEmptyFolder: Driver<Bool>
        let folderCount: Driver<Int>
        let folderOrderTitle: Driver<String>
    }
    
    // MARK: - OUTPUT Relay
    /// EVENT
    private let toastMessage = PublishRelay<String>()
    private let removeBottomAlert = PublishRelay<Void>()
    private let folderShareSheet = PublishRelay<String>()
    
    /// STATE
    private let sections = BehaviorRelay<[FolderSectionData]>(value: [])
    private let isLoading = BehaviorRelay<Bool>(value: true)
    private let isEmptyFolder = BehaviorRelay<Bool>(value: false)
    private let folderCount = BehaviorRelay<Int>(value: 0)
    private let folderFetchType = BehaviorRelay<FolderFetchType>(value: .current)
    private let disposeBag = DisposeBag()

    // Dependcy Injection
    private let networkProvider: MoyaProvider<LinkMoaAPI>
    
    init(networkProvider: MoyaProvider<LinkMoaAPI>) {
        self.networkProvider = networkProvider
    }
    
    func transform(input: Input) -> Output {
        let removeSuccced = PublishRelay<Void>()
        
        let fetchFolderSequence = Signal.merge([
            input.fetchFolders,
            input.fetchFolderOrder.do(onNext: {[weak self] order in
                guard let self = self else { return }
                self.folderFetchType.accept(order)
            }).map { _ in },
            removeSuccced.asSignal()
        ])
        
        fetchFolderSequence.asObservable()
            .do { [weak self] _ in
                guard let self = self else { return }
                self.isLoading.accept(true)
            }
            .flatMap { [weak self] (_) -> Single<Response> in
                guard let self = self else { return Single<Response>.error(DefaultError.flatmap) }
                return self.networkProvider.rx.request(.myFolderList(index: 0, filter: self.folderFetchType.value.rawValue)) }
            .map(FolderList.self)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.isSuccess == false {
                    self.toastMessage.accept(response.message)
                    return
                }
                
                if let folders = response.result {
                    self.sections.accept([.init(items: folders, uniqueID: 0)])
                    self.isEmptyFolder.accept(folders.count == 0)
                    self.folderCount.accept(folders.count)
                }
                
                self.isLoading.accept(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.toastMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        input.removeFolder.asObservable()
            .do { [weak self] _ in
                guard let self = self else { return }
                self.isLoading.accept(true)
            }
            .flatMap { [weak self] (removeIndex: Int) -> Single<Response> in
                guard let self = self else { return Single<Response>.error(DefaultError.flatmap) }
                return self.networkProvider.rx.request(.deleteFolder(index: removeIndex))
            }
            .map(FolderResponse.self)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.isSuccess == false {
                    self.toastMessage.accept(response.message)
                    return
                }
                
                removeSuccced.accept(())
                self.removeBottomAlert.accept(())
                self.isLoading.accept(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.toastMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        input.folderShareTapped.asObservable()
            .flatMap({ [weak self] (index: Int) -> Single<Response> in
                guard let self = self else { return Single<Response>.error(DefaultError.flatmap) }
                return self.networkProvider.rx.request(.folderDetail(index: index))
            })
            .map(FolderDetail.self)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.isSuccess == false {
                    self.toastMessage.accept(response.message)
                    return
                }
                
                if let folderDetail = response.result {
                    self.folderShareSheet.accept(folderDetail.shareItem)
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.toastMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        return Output(
            toastMessage: toastMessage.asSignal(),
            removeBottomAlert: removeBottomAlert.asSignal(),
            folderShareSheet: folderShareSheet.asSignal(),
            sections: sections.asDriver(),
            isLoading: isLoading.asDriver(),
            isEmptyFolder: isEmptyFolder.asDriver(),
            folderCount: folderCount.asDriver(),
            folderOrderTitle: folderFetchType.map { $0.title }.asDriver(onErrorJustReturn: "")
        )
    }
}
