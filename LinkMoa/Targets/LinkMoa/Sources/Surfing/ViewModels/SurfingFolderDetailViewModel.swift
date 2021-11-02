//
//  SurfingFolderDetailViewModel.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/05/14.
//

import Foundation
import LinkMoaCore
import LinkMoaKit

import Moya
import RxCocoa
import RxSwift

final class SurfingFolderDetailViewModel: ViewModelType {
    struct Input {
        let fetchFolderDetail: Signal<Void>
        let likeAction: Signal<Void>
        let reportAction: Signal<Void>
    }
    
    struct Output {
        let folderDetail: Driver<FolderDetail.Result>
        let likeResult: Driver<(status: Int, count: Int)>
        let reportResult: Driver<Bool>
        let isHiddenNoticeView: Driver<Bool>
        let errorMessage: Signal<String>
    }
    
    private let isHiddenNoticeView = BehaviorRelay<Bool>(value: true)
    private let errorMessage = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    private var folderName: String = ""
    private var links: [FolderDetail.Link] = []

    var userNickname: String = ""
    var userIndex: Int = 0
    
    var shareItem: String {
        let links = self.links.map { "\($0.name)\n\($0.url)\n\n" }.joined()
        return self.folderName + "\n\n" + links
    }
    
    // DI
    private let networkManager: MoyaProvider<LinkMoaAPI>
    private let folderIndex: Int

    init(networkManager: MoyaProvider<LinkMoaAPI>, folderIndex: Int) {
        self.networkManager = networkManager
        self.folderIndex = folderIndex
    }
    
    func transform(input: Input) -> Output {
        let folderDetail = input.fetchFolderDetail
            .flatMap { [weak self] _ -> Driver<FolderDetail.Result> in
                guard let self = self else { return Driver.just(FolderDetail.Result.init()) }
                return self.loadFolderInfo(folder: self.folderIndex)
            }
        
        let likeResult = input.likeAction
            .flatMap { [weak self] target -> Driver<(status: Int, count: Int)> in
                guard let self = self else { return Driver.just((0, 0)) }
                return self.likeFolder(folder: self.folderIndex) }
        
        let reportResult = input.reportAction
            .flatMap { [weak self] target -> Driver<Bool> in
                guard let self = self else { return Driver.just(false) }
                return self.reportFolder(folder: self.folderIndex)
            }
        
        return Output(
            folderDetail: folderDetail,
            likeResult: likeResult,
            reportResult: reportResult,
            isHiddenNoticeView: isHiddenNoticeView.asDriver(),
            errorMessage: errorMessage.asSignal()
        )
    }
}

extension SurfingFolderDetailViewModel {
    private func fetchFolderDetail(folder: Int) -> Single<FolderDetail> {
        return self.networkManager.rx.request(.folderDetail(index: folder))
            .map(FolderDetail.self)
    }

    private func loadFolderInfo(folder: Int) -> Driver<FolderDetail.Result> {
        return fetchFolderDetail(folder: folder)
            .map { [weak self] response -> FolderDetail.Result in
                guard let self = self else { return FolderDetail.Result() }
                if let result = response.result, response.isSuccess {
                    self.userNickname = result.userNickname
                    self.userIndex = result.userIndex
                    self.folderName = result.name
                    self.links = result.linkList
                    self.isHiddenNoticeView.accept(!result.linkList.isEmpty)
                    return result
                } else {
                    self.errorMessage.accept(response.message)
                    return FolderDetail.Result()
                }
            }
            .asDriver(onErrorJustReturn: FolderDetail.Result())
    }

    private func likeFolder(folder: Int) -> Driver<(status: Int, count: Int)> {
        let like = fetchFolderDetail(folder: folder)
            .compactMap { $0.result }
            .map {(status: $0.likeStatus, count: $0.likeCount)}
        
        return networkManager.rx.request(.like(index: folder))
            .map(LinkResponse.self)
            .filter { $0.isSuccess }
            .flatMap { _ in like }
            .asDriver(onErrorJustReturn: (status: 0, count: 0))
    }
    
    private func reportFolder(folder: Int) -> Driver<Bool> {
        let params: [String: Any] = ["folderIdx": folder]
        
        return self.networkManager.rx.request(.report(params: params))
            .map(ReportResponse.self)
            .map { [weak self] response in
                guard let self = self else { return false }
                if response.isSuccess {
                    return true
                } else {
                    self.errorMessage.accept(response.message)
                    return false
                }
            }
            .asDriver(onErrorJustReturn: false)
    }
}
