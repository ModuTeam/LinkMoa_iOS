//
//  SearchAssembly.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/25.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation
import LinkMoaCore

import Moya
import Swinject
import RxSwift
import RxRelay

final class SearchAssembly: Assembly {
    func assemble(container: Container) {
        let bundle = Bundle.module

        // Search
        /// SearchLinkResultViewModel
        container.register(SearchLinkResultViewModel.self) {
            (r: Resolver, type: SearchType) in
            SearchLinkResultViewModel(
                networkProvider: r.resolve(MoyaProvider<LinkMoaAPI>.self)!,
                type: type
            )
        }

        /// SearchLinkResultViewController
        container.register(SearchLinkResultViewController.self) {
            (r: Resolver, type: SearchType) in
            let sb = UIStoryboard(name: SearchLinkResultViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController { coder in
                SearchLinkResultViewController(
                    coder: coder,
                    viewModel: r.resolve(SearchLinkResultViewModel.self, argument: type)!,
                    type: type
                )
            }!

            return vc
        }

        /// SearchFolderResultViewModel
        container.register(SearchFolderResultViewModel.self) {
            (r: Resolver, type: SearchType) in
            SearchFolderResultViewModel(
                networkProvider: r.resolve(MoyaProvider<LinkMoaAPI>.self)!,
                type: type
            )
        }

        /// SearchFolderResultViewController
        container.register(SearchFolderResultViewController.self) {
            (r: Resolver, type: SearchType) in
            let sb = UIStoryboard(name: SearchFolderResultViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController { coder in
                SearchFolderResultViewController(
                    coder: coder,
                    viewModel: r.resolve(SearchFolderResultViewModel.self, argument: type)!,
                    type: type
                )
            }!

            return vc
        }

        /// SearchFolderDetailViewController
        container.register(SearchFolderDetailViewController.self) {
            (r: Resolver, folderIndex: Int) in
            let sb = UIStoryboard(name: SearchFolderDetailViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController { coder in
                SearchFolderDetailViewController(
                    coder: coder,
                    viewModel: r.resolve(FolderDetailViewModel.self, argument: folderIndex)!,
                    removeFolderTrigger: PublishRelay<Int>()
                )
            }!

            return vc
        }

        /// SearchViewController
        container.register(SearchViewController.self) {
            (r: Resolver, type: SearchType) in
            let sb = UIStoryboard(name: SearchViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController { coder in
                SearchViewController(
                    coder: coder,
                    type: type
                )
            }!

            return vc
        }

        /// SearchNavigtionController
        container.register(SearchNavigationController.self) { (r: Resolver, type: SearchType) in
            let vc = r.resolve(SearchViewController.self, argument: type)!
            return SearchNavigationController(rootViewController: vc)
        }
    }
}
