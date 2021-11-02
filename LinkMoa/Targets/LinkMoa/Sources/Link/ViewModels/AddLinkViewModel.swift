//
//  AddLinkViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/08/06.
//

import Foundation
import LinkMoaCore
import LinkMoaKit

import RxSwift
import RxCocoa
import Moya

typealias SelectFolder = (name: String, index: Int)

enum AddLinkAction {
    // 현재 폴더에 추가
    case add(link: FolderDetail.Link, folderIndex: Int)
    // 현재 폴더에서 수정
    case edit(link: FolderDetail.Link, folderIndex: Int)
    // 현재 폴더에서 삭제 후 목적지 폴더에서 추가
    case move(link: FolderDetail.Link, folderIndex: Int)
}

final class AddLinkViewModel: ViewModelType {
    struct Input {
        let changeSelectFolder: Signal<SelectFolder>
        let changeLinkName: Signal<String?>
        let changeLinkURL: Signal<String?>
        let saveButtonTapped: Signal<Void>
        let requestURLTitle: Signal<String>
    }
    
    struct Output {
        let title: Driver<String>
        let linkName: Driver<String>
        let linkURL: Driver<String>
        let selectFolderName: Driver<String>
        let isSelectFolderNoticeHidden: Driver<Bool>
        let isLoading: Driver<Bool>
        let toastMessage: Signal<String>
        let linkActionSucceed: Signal<Void>
    }
    
    struct Dependency {
        var currentFolder: SelectFolder? // 현재 폴더
        var destinationFolder: SelectFolder? // 이동하려는 폴더
        var link: FolderDetail.Link? // 현재 link, 추가시에는 nil
        let actionType: EditPresetingStyle // 링크 action 을 나타내는 enum
        
        mutating func selectDestinationFolder(by selectFolder: SelectFolder) {
            destinationFolder = selectFolder
        }
        
        mutating func changeLinkName(by name: String) {
            link = link?.changeName(by: name)
        }
        
        mutating func changeLinkURL(by url: String) {
            link = link?.changeURL(by: url)
        }
    }
    
    private let title = BehaviorRelay<String>(value: "")
    private let linkName = BehaviorRelay<String>(value: "")
    private let linkURL = BehaviorRelay<String>(value: "")
    private let selectFolderName = BehaviorRelay<String>(value: "")
    private let isSelectFolderNoticeHidden = BehaviorRelay<Bool>(value: false)
    private let isLoading = BehaviorRelay<Bool>(value: false)
    private let toastMessage = PublishRelay<String>()
    private let linkActionSucceed = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    private let linkService: LinkPresentaionService
    private let networkProvider: MoyaProvider<LinkMoaAPI>
    var dependency: Dependency
    
    var actionType: EditPresetingStyle {
        return self.dependency.actionType
    }
    
    // 의존성 주입 수정 예정
    init(
        networkProvider: MoyaProvider<LinkMoaAPI>,
        linkService: LinkPresentaionService,
        dependency: Dependency
    ) {
        self.networkProvider = networkProvider
        self.linkService = linkService
        self.dependency = dependency
    }
    
    func transform(input: Input) -> Output {
        let linkActionTrigger = PublishRelay<AddLinkAction>()
        
        input.saveButtonTapped
            .filter { [weak self] _ in
                guard let self = self else { return false }
                return self.validationLink()
            }
            .emit { [weak self] _ in
                guard let self = self else { return }
                guard let link = self.dependency.link else { return }
                let dependency = self.dependency
                let action = dependency.actionType
                
                switch action {
                case .add, .share:
                    let selectFolder = dependency.destinationFolder ?? dependency.currentFolder
                    
                    if let selectFolder = selectFolder {
                        linkActionTrigger.accept(.add(link: link, folderIndex: selectFolder.index))
                        return
                    }
                case .edit:
                    guard let currentSelectFolder = dependency.currentFolder else { return }
                    let destinationSelectFolder = dependency.destinationFolder
                
                    // 목적지 폴더가 존재한다면 current 폴더에서 삭제 후, 다시 추가하는 동작
                    if let destinationSelectFolder = destinationSelectFolder {
                        linkActionTrigger.accept(
                            .move(
                                link: link,
                                folderIndex: destinationSelectFolder.index
                            )
                        )
                    } else {
                        linkActionTrigger.accept(
                            .edit(link: link, folderIndex: currentSelectFolder.index)
                        )
                    }
                }
            }
            .disposed(by: disposeBag)
        
        linkActionTrigger
            .do { [weak self] _ in
                guard let self = self else { return }
                self.isLoading.accept(true)
            }
            .flatMap { [weak self] action -> Single<Response> in
                guard let self = self else { return Single.error(DefaultError.flatmap) }

                switch action {
                case .add(let link, let folderIndex):
                    return self.addLink(link: link, folderIndex: folderIndex)
                case .edit(let link, let folderIndex):
                    return self.editLink(link: link, folderIndex: folderIndex)
                case .move(let link, let folderIndex):
                    return self.moveLink(link: link, folderIndex: folderIndex)
                }
            }
            .map(FolderResponse.self)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.isLoading.accept(false)

                guard response.isSuccess else {
                    self.toastMessage.accept(response.message)
                    return
                }

                self.linkActionSucceed.accept(())
            }, onError: { _ in
                self.isLoading.accept(false)
                self.toastMessage.accept("서버 에러가 발생했습니다.")
            })
            .disposed(by: disposeBag)
            
        input.changeSelectFolder
            .emit { [weak self] selectFolder in
                guard let self = self else { return }
                self.dependency.selectDestinationFolder(by: selectFolder)
                self.selectFolderName.accept(selectFolder.name)
                self.isSelectFolderNoticeHidden.accept(true)
            }
            .disposed(by: disposeBag)
        
        input.changeLinkName
            .distinctUntilChanged()
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .emit { [weak self] in
                guard let self = self else { return }
                self.dependency.changeLinkName(by: $0)
            }
            .disposed(by: disposeBag)
        
        input.changeLinkURL
            .distinctUntilChanged()
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .emit { [weak self] in
                guard let self = self else { return }
                self.dependency.changeLinkURL(by: $0)
            }
            .disposed(by: disposeBag)
        
        // Share Extension 에서 접근했을 때 자동으로 URL, Title 을 입력해주는 기능
        input.requestURLTitle
            .asObservable()
            .flatMap { [weak self] url -> Single<String> in
                guard let self = self else { return Single.error(DefaultError.flatmap) }
                self.dependency.link = self.dependency.link?.changeURL(by: url)
                self.linkURL.accept(url)
                return self.linkService.fetchTitle(urlString: url)
            }
            .subscribe(onNext: { [weak self] webTitle in
                guard let self = self else { return }
                let title = String(webTitle.trimmingCharacters(in: .whitespaces).prefix(20))
                self.dependency.link = self.dependency.link?.changeName(by: title)
                self.linkName.accept(title)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.toastMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // 초기값 설정
        // 링크 액션에 따른 title 변경
        self.title.accept(dependency.actionType.title)
        
        // 링크 수정일 경우, 기존 링크 데이터를 불러옴
        if dependency.actionType == .edit, let link = dependency.link {
            self.linkName.accept(link.name)
            self.linkURL.accept(link.url)
        }
        
        // 지정한 폴더가 있을 경우 ex) 폴더 내에서 링크 추가, 링크 수정
        if let folder = dependency.currentFolder {
            self.selectFolderName.accept(folder.name)
            self.isSelectFolderNoticeHidden.accept(true)
        }
        
        return Output(
            title: title.asDriver(),
            linkName: linkName.asDriver(),
            linkURL: linkURL.asDriver(),
            selectFolderName: selectFolderName.asDriver(),
            isSelectFolderNoticeHidden: isSelectFolderNoticeHidden.asDriver(),
            isLoading: isLoading.asDriver(),
            toastMessage: toastMessage.asSignal(),
            linkActionSucceed: linkActionSucceed.asSignal()
        )
    }
    
    private func validationLink() -> Bool {
        guard let link = self.dependency.link else { return false }
        
        guard !link.name.isEmpty else {
            self.toastMessage.accept("링크 이름을 입력해주세요.")
            return false
        }
        
        guard link.name.count <= 30 else {
            self.toastMessage.accept("링크 이름은 30자를 넘길 수 없습니다.")
            return false
        }
        
        guard !link.url.isEmpty else {
            self.toastMessage.accept("URL을 입력해주세요.")
            return false
        }
        
        guard link.url.isValidHttps() else {
            self.toastMessage.accept("올바른 링크 주소를 입력해주세요.")
            return false
        }
        
        guard self.dependency.currentFolder != nil ||
              self.dependency.destinationFolder != nil
        else {
            self.toastMessage.accept("저장할 폴더를 선택해주세요.")
            return false
        }
        
        return true
    }
}

extension AddLinkViewModel {
    private func addLink(link: FolderDetail.Link, folderIndex: Int) -> Single<Response> {
        return self.linkService.fetchMetaDataURL(targetURLString: link.url)
            .flatMap { [weak self] metaData -> Single<Response> in
                guard let self = self else { return Single.error(DefaultError.flatmap) }
                
                var param: [String: Any] = ["linkName": link.name, "linkUrl": link.url]
                
                if let faviconURLString = metaData.faviconURLString {
                    param["linkFaviconUrl"] = faviconURLString
                }
                
                if let webPreviewURLString = metaData.webPreviewURLString {
                    param["linkImageUrl"] = webPreviewURLString
                }
                
                return self.networkProvider.rx.request(.addLink(index: folderIndex, params: param))
            }
    }
    
    private func editLink(link: FolderDetail.Link, folderIndex: Int) -> Single<Response> {
        return self.linkService.fetchMetaDataURL(targetURLString: link.url)
            .flatMap { [weak self] metaData -> Single<Response> in
                guard let self = self else { return Single.error(DefaultError.flatmap) }
                guard let link = self.dependency.link else { fatalError() }
                
                var param: [String: Any] = ["linkName": link.name, "linkUrl": link.url]
                
                if let faviconURLString = metaData.faviconURLString {
                    param["linkFaviconUrl"] = faviconURLString
                }
                
                if let webPreviewURLString = metaData.webPreviewURLString {
                    param["linkImageUrl"] = webPreviewURLString
                }
                
                return self.networkProvider.rx.request(.editLink(index: link.index, params: param))
            }
    }
    
    private func moveLink(
        link: FolderDetail.Link,
        folderIndex: Int
    ) -> Single<Response> {
        return networkProvider.rx
            .request(.deleteLink(index: link.index))
            .map(FolderResponse.self)
            .flatMap { [weak self] response -> Single<WebMetaData> in
                guard let self = self else { return Single.error(DefaultError.flatmap) }
                guard response.isSuccess else { return Single.error(DefaultError.network) }
                
                return self.linkService.fetchMetaDataURL(targetURLString: link.url)
            }
            .flatMap { [weak self] metaData -> Single<Response> in
                guard let self = self else { return Single.error(DefaultError.flatmap) }
                
                var param: [String: Any] = ["linkName": link.name, "linkUrl": link.url]
                
                if let faviconURLString = metaData.faviconURLString {
                    param["linkFaviconUrl"] = faviconURLString
                }
                
                if let webPreviewURLString = metaData.webPreviewURLString {
                    param["linkImageUrl"] = webPreviewURLString
                }
                
                return self.networkProvider.rx.request(
                    .addLink(index: folderIndex, params: param)
                )
            }
    }
}
