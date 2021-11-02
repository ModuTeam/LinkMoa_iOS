//
//  GaribiAssembly.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/11.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation
import LinkMoaCore

import Moya
import Swinject
import RxSwift
import RxRelay

final class GaribiAssembly: Assembly {
    func assemble(container: Container) {
        let bundle = Bundle.module
        
        // Folder
        /// FolderViewModel
        container.register(FolderViewModel.self) { r in
            FolderViewModel(networkProvider: r.resolve(MoyaProvider<LinkMoaAPI>.self)!)
        }
        
        /// FolderViewController
        container.register(FolderViewController.self) { r in
            let sb = UIStoryboard(name: FolderViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController { corder in
                FolderViewController(coder: corder, viewModel: r.resolve(FolderViewModel.self)!)
            }!
            
            return vc
        }
        
        /// FolderDetailViewModel
        container.register(FolderDetailViewModel.self) { (r: Resolver, folderIndex: Int) in
            FolderDetailViewModel(
                networkProvider: r.resolve(MoyaProvider<LinkMoaAPI>.self)!,
                folderIndex: folderIndex
            )
        }
        
        /// FolderDetailViewController
        container.register(FolderDetailViewController.self) {
            (r: Resolver, folderIndex: Int, trigger: PublishRelay<Int>) in
            let sb = UIStoryboard(name: FolderDetailViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController { corder in
                FolderDetailViewController(
                    coder: corder,
                    viewModel: r.resolve(FolderDetailViewModel.self, argument: folderIndex)!,
                    removeFolderTrigger: trigger
                )
            }!
            
            return vc
        }
        
        /// AddFolderViewModel
        container.register(AddFolderViewModel.self) {
            (r: Resolver, type: AddFolderType, folderIndex: Int) in
            AddFolderViewModel(
                networkProvider: r.resolve(MoyaProvider<LinkMoaAPI>.self)!,
                dataManager: r.resolve(AddFolderDataManager.self, argument: folderIndex)!,
                type: type
            )
        }
        
        /// AddFolderViewController
        container.register(AddFolderViewController.self) {
            (r: Resolver, type: AddFolderType, folderIndex: Int, trigger: PublishRelay<Void>) in
            let sb = UIStoryboard(name: AddFolderViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController { coder in
                AddFolderViewController(
                    coder: coder,
                    viewModel: r.resolve(AddFolderViewModel.self, argument: type)!,
                    folderAddSucceedTrigger: trigger
                )
            }!
            
            return vc
        }
        
        /// AddFolderDataManager
        container.register(AddFolderDataManager.self) { (_, folderIndex: Int) in
            let manager = AddFolderDataManager()
            manager.index = folderIndex
            return manager
        }
        
        /// AddFolderCategoryViewModel
        container.register(AddFolderCategoryViewModel.self) {
            (r: Resolver, dataManager: AddFolderDataManager, type: AddFolderType) in
            AddFolderCategoryViewModel(
                networkProvider: r.resolve(MoyaProvider<LinkMoaAPI>.self)!,
                dataManager: dataManager,
                type: type
            )
        }
        
        /// AddFolderCategoryViewController
        container.register(AddFolderCategoryViewController.self) {
            (r: Resolver, dataManager: AddFolderDataManager, type: AddFolderType, trigger: PublishRelay<Void>) in
            let sb = UIStoryboard(name: AddFolderCategoryViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController { coder in
                AddFolderCategoryViewController(
                    coder: coder,
                    viewModel: r.resolve(AddFolderCategoryViewModel.self, arguments: dataManager, type)!,
                    folderAddSucceedTrigger: trigger
                )
            }!
            
            return vc
        }
        
        /// AddFolderNavigationController
        container.register(AddFolderNavigationController.self) {
            (r: Resolver, type: AddFolderType, folderIndex: Int, trigger: PublishRelay<Void>) in
            let sb = UIStoryboard(name: AddFolderViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController { corder in
                AddFolderViewController(
                    coder: corder,
                    viewModel: r.resolve(AddFolderViewModel.self, arguments: type, folderIndex)!,
                    folderAddSucceedTrigger: trigger
                )
            }!
            
            return AddFolderNavigationController(rootViewController: vc)
        }
    }
}
