//
//  HomeAssembly.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/11.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation

import Swinject

final class HomeAssembly: Assembly {
    func assemble(container: Container) {
        let bundle = Bundle.module
        
        // Home
        /// HomeViewController
        container.register(HomeViewController.self) { r in
            let sb = UIStoryboard(name: HomeViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController { corder in
                HomeViewController(
                    coder: corder,
                    folderVC: r.resolve(FolderViewController.self)!,
                    surfingVC: r.resolve(SurfingViewController.self)!
                )
            }!
            
            return vc
        }
        
        /// HomeNavigationViewController
        container.register(HomeNavigationController.self) { r in
            HomeNavigationController(rootViewController: r.resolve(HomeViewController.self)!)
        }
        
        // Splash
        /// SplashViewController
        container.register(SplashViewController.self) { _ in
            let sb = UIStoryboard(name: SplashViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController()
            return vc as! SplashViewController
        }
    }
}
