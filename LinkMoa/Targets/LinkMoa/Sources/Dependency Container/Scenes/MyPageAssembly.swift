//
//  MyPageAssembly.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/12.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation
import LinkMoaCore

import Moya
import Swinject

final class MyPageAssembly: Assembly {
    func assemble(container: Container) {
        let bundle = Bundle.module
        
        // MyPage
        /// MyPageViewModel
        container.register(MyPageViewModel.self) { r in
            MyPageViewModel(
                networkProvider: r.resolve(MoyaProvider<LinkMoaAPI>.self)!,
                tokenManager: r.resolve(TokenManager.self)!
            )
        }
        
        /// MyPageViewController
        container.register(MyPageViewController.self) { r in
            let sb = UIStoryboard(name: MyPageViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController { corder in
                MyPageViewController(coder: corder, viewModel: r.resolve(MyPageViewModel.self)!)
            }!
            
            return vc
        }
        
        // MyPageNavigationViewController
        container.register(MyPageNavigationController.self) { r in
            MyPageNavigationController(rootViewController: r.resolve(MyPageViewController.self)!)
        }
        
        // FAQViewController
        container.register(FAQViewController.self) { _ in
            let sb = UIStoryboard(name: FAQViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController() as! FAQViewController
            return vc
        }
        
        // OpenSourcesViewController
        container.register(OpenSourceViewController.self) { _ in
            OpenSourceViewController()
        }
        
        // OpenSourceNavigationController
        container.register(OpenSourceNavigationController.self) { r in
            OpenSourceNavigationController(rootViewController: r.resolve(OpenSourceViewController.self)!)
        }
    }
}
