//
//  SurfingAssembly.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/11.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation
import LinkMoaCore

import Moya
import Swinject

final class SurfingAssembly: Assembly {
    func assemble(container: Container) {
        let bundle = Bundle.module
        
        // Surfing
        /// SurfingViewModel
        container.register(SurfingViewModel.self) { r in
            SurfingViewModel(networkProvider: r.resolve(MoyaProvider<LinkMoaAPI>.self)!)
        }
        
        /// SurfingViewController
        container.register(SurfingViewController.self) { r in
            return SurfingViewController(viewModel: r.resolve(SurfingViewModel.self)!)
        }
        
        /// SurfingFolderDetailViewModel
        container.register(SurfingFolderDetailViewModel.self) {
            (r: Resolver, folderIndex: Int) in
            SurfingFolderDetailViewModel(
                networkManager: r.resolve(MoyaProvider<LinkMoaAPI>.self)!,
                folderIndex: folderIndex
            )
        }
        
        /// SurfingFolderDetailViewController
        container.register(SurfingFolderDetailViewController.self) {
            (r: Resolver, folderIndex: Int) in
            let sb = UIStoryboard(
                name: SurfingFolderDetailViewController.storyboardName(),
                bundle: bundle
            )
            let vc = sb.instantiateInitialViewController { corder in
                SurfingFolderDetailViewController(
                    coder: corder,
                    viewModel: r.resolve(SurfingFolderDetailViewModel.self, argument: folderIndex)!
                )
            }!
            
            return vc
        }
        
        /// SurfingFolderViewModel
        container.register(SurfingFolderViewModel.self) { (r: Resolver, type: SurfingFolderType) in
            SurfingFolderViewModel(
                networkManager: r.resolve(MoyaProvider<LinkMoaAPI>.self)!,
                type: type
            )
        }
        
        /// SurfingFolderViewController
        container.register(SurfingFolderViewController.self) {
            (r: Resolver, type: SurfingFolderType) in
            return SurfingFolderViewController(viewModel: r.resolve(SurfingFolderViewModel.self, argument: type)!)
        }
        
        /// SurfingCategoryViewModel
        container.register(SurfingCategoryViewModel.self) { (r: Resolver, index: Int) in
            SurfingCategoryViewModel(
                networkProvider: r.resolve(MoyaProvider<LinkMoaAPI>.self)!,
                folderMainIndex: index
            )
        }
        
        /// SurfingCategoryViewController
        container.register(SurfingCategoryViewController.self) { (r: Resolver, index: Int) in
            return SurfingCategoryViewController(viewModel: r.resolve(SurfingCategoryViewModel.self, argument: index)!)
        }
    }
}
