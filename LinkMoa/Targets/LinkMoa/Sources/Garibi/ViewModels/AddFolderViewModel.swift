//
//  AddFolderViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/09.
//

import Foundation
import LinkMoaKit
import LinkMoaCore

import RxSwift
import RxCocoa
import Moya

final class AddFolderViewModel: ViewModelType {
    struct Input {
        let fetchFolder: Signal<Void>
        let changeShareType: Signal<FolderShareType>
        let changeFolderName: Signal<String>
        let addTag: Signal<String>
        let removeTag: Signal<String>
    }
    
    struct Output {
        let errorMessage: Signal<String>
        let isLoading: Driver<Bool>
        let folderName: Driver<String>
        let sections: Driver<[TagSectionModel]>
        let shareType: Driver<FolderShareType>
        let isShowTagNotification: Driver<Bool>
        let title: Driver<String>
    }
    
    private let errorMessage = PublishRelay<String>()
    private let isLoading = BehaviorRelay<Bool>(value: false)
    private let folderName  = BehaviorRelay<String>(value: "")
    private let sections = BehaviorRelay<[TagSectionModel]>(value: [])
    private let shareType = BehaviorRelay<FolderShareType>(value: .private)
    private let isShowTagNotification = BehaviorRelay<Bool>(value: true)
    private let title = BehaviorRelay<String>(value: "")
    private var tags = [String]()
    private let disposeBag = DisposeBag()
    
    private var categoryIndex = 0
    private var detailCategoryIndex = 0
    
    var addFolderType: AddFolderType {
        return type
    }
    
    var addFolderDataManager: AddFolderDataManager {
        dataManager.categoryIdx = categoryIndex
        dataManager.detailCategoryIdx = detailCategoryIndex
        dataManager.folderName = folderName.value
        dataManager.hashTagList = tags
        dataManager.isShared = shareType.value == .public
        return dataManager
    }
    
    // Dependency Injection
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
        input.fetchFolder
            .asObservable()
            .filter { [weak self] in // 폴더 추가시에는 네트워크 로드 필요 없음
                guard let self = self else { return true }
                return self.type == .edit
            }
            .do { [weak self] _ in
                guard let self = self else { return }
                self.isLoading.accept(true)
            }
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single.error(DefaultError.flatmap )}
                return self.networkProvider.rx.request(.folderDetail(index: self.dataManager.index))
            }
            .map(FolderDetail.self)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                
                if response.isSuccess == false {
                    self.errorMessage.accept(response.message)
                    return
                }
                
                if let folder = response.result {
                    self.categoryIndex = folder.categoryIndex
                    self.detailCategoryIndex = folder.detailCategoryIndex ?? 0
                    
                    self.folderName.accept(folder.name)
                    self.tags = folder.hashTagList.map { $0.name }
                    self.sections.accept([.init(items: self.tags, uniqueID: 0)])
                    self.shareType.accept(folder.type == "public" ? .public : .private)
                    self.isShowTagNotification.accept(folder.hashTagList.count == 0 ? true : false)
                }
                
                self.isLoading.accept(false)
            }, onError: { [weak self] _ in
                guard let self = self else { return }
                self.errorMessage.accept("서버 에러가 발생했습니다.")
            })
            .disposed(by: disposeBag)
        
        input.changeShareType
            .emit { [weak self] type in
                guard let self = self else { return }
                self.shareType.accept(type)
            }
            .disposed(by: disposeBag)
        
        input.addTag
            .emit { [weak self] tag  in
                guard let self = self else { return }
                var currentTags = self.tags
                
                guard !tag.isEmpty else {
                    self.errorMessage.accept("태그를 입력해주세요")
                    return
                }
                
                guard tag.count <= 10 else {
                    self.errorMessage.accept("태그는 10자를 넘길 수 없습니다.")
                    return
                }
                
                guard currentTags.firstIndex(of: tag) == nil else {
                    self.errorMessage.accept("중복된 태그가 존재합니다.")
                    return
                }
                
                guard currentTags.count + 1 <= 3 else {
                    self.errorMessage.accept("태그는 3개를 초과할 수 없습니다.")
                    return
                }
                
                currentTags.insert(tag, at: 0)
                self.isShowTagNotification.accept(currentTags.count == 0)
                self.tags = currentTags
                self.sections.accept([.init(items: self.tags, uniqueID: 0)])
            }
            .disposed(by: disposeBag)
        
        input.removeTag
            .emit { [weak self] tag in
                guard let self = self else { return }
                let tags = self.tags.filter({ $0 != tag })
                self.isShowTagNotification.accept(tags.count == 0 ? true : false)
                self.tags = tags
                self.sections.accept([.init(items: self.tags, uniqueID: 0)])
            }
            .disposed(by: disposeBag)
        
        input.changeFolderName
            .emit { [weak self] name in
                guard let self = self else { return }
                self.folderName.accept(name)
            }
            .disposed(by: disposeBag)
        
        // 초기값 설정
        title.accept(self.type.title)
        
        return Output(
            errorMessage: errorMessage.asSignal(),
            isLoading: isLoading.asDriver(),
            folderName: folderName.asDriver(),
            sections: sections.asDriver(),
            shareType: shareType.asDriver(),
            isShowTagNotification: isShowTagNotification.asDriver(),
            title: title.asDriver()
        )
    }
}
