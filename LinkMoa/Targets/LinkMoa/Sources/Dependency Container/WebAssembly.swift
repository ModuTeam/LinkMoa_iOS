//
//  HelpAssembly.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/21.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation
import LinkMoaCore

import Moya
import Swinject
import UIKit

final class WebAssembly: Assembly {
    func assemble(container: Container) {
        let bundle = Bundle.module

        // Web
        /// WebManager
        container.register(WebManager.self) { (r: Resolver, vc: UIViewController) in
            WebManager(
                tokenManager: r.resolve(TokenManager.self)!,
                application: UIApplication.shared,
                targetVC: vc
            )
        }
        
        /// WebViewController
        container.register(WebViewController.self) { (r: Resolver, url: URL) in
            let sb = UIStoryboard(name: WebViewController.storyboardName(), bundle: bundle)
            let vc = sb.instantiateInitialViewController { coder in
                WebViewController(coder: coder, url: url)
            }!
            
            return vc
        }
    }
}
