//
//  LoginAssembly.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/12.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation
import LinkMoaCore

import Moya
import Swinject

final class LoginAssembly: Assembly {
    func assemble(container: Container) {
        let bundle = Bundle.module
        
        // Login
        /// LoginViewModel
        container.register(LoginViewModel.self) { r in
            LoginViewModel(
                linkMoaProvider: r.resolve(MoyaProvider<LinkMoaAPI>.self)!,
                loginProvider: r.resolve(MoyaProvider<LoginAPI>.self)!,
                tokenManager: r.resolve(TokenManager.self)!
            )
        }
        
        /// LoginViewController
        container.register(LoginViewController.self) { r in
            let sb = UIStoryboard(name: LoginViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController { corder in
                LoginViewController(coder: corder, viewModel: r.resolve(LoginViewModel.self)!)
            }!
            
            return vc
        }
        
        // Register
        /// RegisterNicknameViewModel
        container.register(RegisterNicknameViewModel.self) { r in
            RegisterNicknameViewModel(
                linkMoaProvider: r.resolve(MoyaProvider<LinkMoaAPI>.self)!,
                registerDataManager: RegisterDataManager()
            )
        }
        
        /// RegisterNicknameViewController
        container.register(RegisterNicknameViewController.self) { r in
            let sb = UIStoryboard(name: RegisterNicknameViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController { corder in
                RegisterNicknameViewController(
                    coder: corder,
                    viewModel: r.resolve(RegisterNicknameViewModel.self)!
                )
            }!
            
            return vc
        }
        
        /// RegisterNicknameNavigationController
        container.register(RegisterNavigationController.self) { r in
            RegisterNavigationController(
                rootViewController: r.resolve(RegisterNicknameViewController.self)!
            )
        }
        
        /// RegisterCategoryViewController
        container.register(RegisterCategoryViewController.self) { (_, dataManager: RegisterDataManager) in
            let sb = UIStoryboard(
                name: RegisterCategoryViewController.storyboardName(),
                bundle: bundle
            )
            
            let vc = sb.instantiateInitialViewController { corder in
                RegisterCategoryViewController(coder: corder, registerDataManager: dataManager)
            }!
            
            return vc
        }
        
        /// RegisterDetailCategoryViewModel
        container.register(RegisterDetailCategoryViewModel.self) { (r: Resolver, dataManager: RegisterDataManager) in
            RegisterDetailCategoryViewModel(
                linkMoaProvider: r.resolve(MoyaProvider<LinkMoaAPI>.self)!,
                registerDataManager: dataManager
            )
        }
        
        /// RegisterDetailCategoryViewController
        container.register(RegisterDetailCategoryViewController.self) { (r: Resolver, dataManager: RegisterDataManager) in
            let sb = UIStoryboard(
                name: RegisterDetailCategoryViewController.storyboardName(),
                bundle: bundle
            )
            
            let vc = sb.instantiateInitialViewController { corder in
                RegisterDetailCategoryViewController(
                    coder: corder,
                    viewModel: r.resolve(RegisterDetailCategoryViewModel.self, argument: dataManager)!
                )
            }!
            
            return vc
        }
    }
}
