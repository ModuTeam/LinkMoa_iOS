//
//  CoreAssembly.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/11.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation
import LinkMoaCore

import Moya
import Swinject
import LinkPresentation

final class CoreAssembly: Assembly {
    func assemble(container: Container) {
        // LinkMoaCore
        /// network
        container.register(MoyaProvider<LinkMoaAPI>.self) { _ in
            MoyaProvider<LinkMoaAPI>()
        }
        container.register(MoyaProvider<LoginAPI>.self) { _ in
            MoyaProvider<LoginAPI>()
        }
        
        /// LinkPresentaionService
        container.register(LinkPresentaionService.self) { _ in
            LinkPresentaionService(
                urlSession: URLSession.shared,
                metadataProvider: LPMetadataProvider()
            )
        }
        
        /// token
        container.register(TokenManager.self) { _ in
            TokenManager()
        }
        
        /// window
        container.register(UIWindow.self) { _ in
            UIApplication.shared.windows.filter({$0.isKeyWindow}).first!
        }
    }
}

