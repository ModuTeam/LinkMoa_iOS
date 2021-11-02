//
//  DIContainer.swift
//  LinkMoaKit
//
//  Created by won heo on 2021/10/11.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation

import Swinject

final class DIContainer {
    static let shared = DIContainer()
    private let container = Container()
    private let assembler: Assembler
    
    private init() {
        assembler = Assembler(
            [
                CoreAssembly(),
                WebAssembly(),
                SceneAssembly()
            ],
            container: container
        )
    }
}

extension DIContainer {
    func resolve<T>() -> T {
        guard let resolved = container.resolve(T.self) else {
            fatalError("resolve failed")
        }
        
        return resolved
    }
    
    func resolve<T, Arg>(argument: Arg) -> T {
        guard let resolved = container.resolve(T.self, argument: argument) else {
            fatalError("resolve failed")
        }
        
        return resolved
    }
    
    func resolve<T, Arg1, Arg2>(arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let resolved = container.resolve(T.self, arguments: arg1, arg2) else {
            fatalError("resolve failed")
        }
        
        return resolved
    }
    
    func resolve<T, Arg1, Arg2, Arg3>(arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> T {
        guard let resolved = container.resolve(T.self, arguments: arg1, arg2, arg3) else {
            fatalError("resolve failed")
        }
        
        return resolved
    }
}
