//
//  WebManager.swift
//  LinkMoaKit
//
//  Created by won heo on 2021/10/21.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import UIKit
import LinkMoaCore

final class WebManager {
    private let tokenManager: TokenManager
    private let application: UIApplication
    private weak var targetVC: UIViewController?
    
    init(tokenManager: TokenManager, application: UIApplication, targetVC: UIViewController) {
        self.tokenManager = tokenManager
        self.application = application
        self.targetVC = targetVC
    }
    
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            fatalError("URL is invalid")
        }
        
        let isUsingCustomBrowser = tokenManager.isUsingCustomBrowser ?? false
        
        if isUsingCustomBrowser {
            let vc: WebViewController = DIContainer.shared.resolve(argument: url)
            vc.modalPresentationStyle = .fullScreen
            targetVC?.present(vc, animated: true)
        } else {
            application.open(url, options: [:])
        }
    }
}
