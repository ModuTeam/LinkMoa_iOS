//
//  SceneAssembly.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/11.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation
import LinkMoaCore

import Moya
import Swinject

final class SceneAssembly: Assembly {
    func assemble(container: Container) {
        let assemblies: [Assembly] = [
            GaribiAssembly(),
            SurfingAssembly(),
            HomeAssembly(),
            LoginAssembly(),
            MyPageAssembly(),
            SearchAssembly(),
            LinkAssembly()
        ]
        
        assemblies.forEach { $0.assemble(container: container) }
    }
}
