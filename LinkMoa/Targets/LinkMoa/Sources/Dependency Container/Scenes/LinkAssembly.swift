//
//  LinkAssembly.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/27.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation
import LinkMoaCore

import Moya
import Swinject
import RxSwift
import RxRelay

final class LinkAssembly: Assembly {
    func assemble(container: Container) {
        let bundle = Bundle.module
        
        /// AddLinkViewModel
        container.register(AddLinkViewModel.self) {
            (r: Resolver, dependency: AddLinkViewModel.Dependency) in
            AddLinkViewModel(
                networkProvider: r.resolve(MoyaProvider<LinkMoaAPI>.self)!,
                linkService: r.resolve(LinkPresentaionService.self)!,
                dependency: dependency
            )
        }
        
        /// AddLinkViewController
        container.register(AddLinkViewController.self) {
            (r: Resolver, dependency: AddLinkViewModel.Dependency, trigger: PublishRelay<Void>) in
            let sb = UIStoryboard(name: AddLinkViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController { coder in
                AddLinkViewController(
                    coder: coder,
                    viewModel: r.resolve(AddLinkViewModel.self, argument: dependency)!,
                    folderAddSucceedTrigger: trigger
                )
            }!
            
            return vc
        }
        
        /// SelectNaviagitonController
        container.register(SelectNaviagitonController.self) {
            (r: Resolver, dependency: AddLinkViewModel.Dependency, trigger: PublishRelay<Void>) in
            SelectNaviagitonController(
                rootViewController: r.resolve(
                    AddLinkViewController.self,
                    arguments: dependency,
                    trigger
                )!
            )
        }
    }
}

