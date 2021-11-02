//
//  AppDelegate.swift
//  LinkMoa
//
//  Created by won heo on 2021/01/28.
//

import LinkMoaCore
import LinkMoaKit
import UIKit

import GoogleSignIn
import Toast_Swift
import Swinject
import Moya

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        appSettings()
        
        let splashVC: SplashViewController = DIContainer.shared.resolve()
        window?.rootViewController = splashVC
        window?.makeKeyAndVisible()
        coordinateRootVC(launchURL: launchOptions?[.url] as? URL)
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        guard let scheme = url.scheme else { return false }
        
        if scheme.contains("com.googleusercontent.apps") {
            let handled = GIDSignIn.sharedInstance.handle(url)
            return handled
        }
        
        if scheme.contains("linkmoa") {
            guard let homeNC = window?.rootViewController as? HomeNavigationController
            else {
                return false
            }
            let folderIndex = Int(url.host ?? "0") ?? 0
            let folderVC: SurfingFolderDetailViewController = DIContainer.shared.resolve(
                argument: folderIndex
            )
            folderVC.homeNC = homeNC
            
            homeNC.dismiss(animated: false)
            homeNC.popToRootViewController(animated: false)
            homeNC.pushViewController(folderVC, animated: false)
            return true
        }
        
        return false
    }
}

extension AppDelegate {
    private func appSettings() {
        containerSetting()
        googleSignSetting()
        toastSwiftSetting()
    }
    
    private func googleSignSetting() {
        _ = GoogleSign.shared
    }
    
    private func toastSwiftSetting() {
        ToastManager.shared.style.activityBackgroundColor = .clear
        ToastManager.shared.style.activityIndicatorColor = .linkMoaDarkBlueColor
    }
    
    private func containerSetting() {
        _ = DIContainer.shared
    }
    
    private func coordinateRootVC(launchURL url: URL?) {
        let loginVC: LoginViewController = DIContainer.shared.resolve()
        let tokenManager: TokenManager = DIContainer.shared.resolve()
        let networkProvider: MoyaProvider<LinkMoaAPI> = DIContainer.shared.resolve()
        
        guard tokenManager.jwt != nil else {
            self.window?.rootViewController = loginVC
            return
        }
        
        networkProvider.request(.userInformation) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                if let userInfo = try? JSONDecoder().decode(UserInformation.self, from: response.data) {
                    if let info = userInfo.result?.first, info.categoryIndex != -1 {
                        // [홈 화면] -> 회원, 정보까지 입력된 상태
                        let homeNC: HomeNavigationController = DIContainer.shared.resolve()
                        self.window?.rootViewController = homeNC
                        
                        // URL접근(위젯)
                        if let url = url, let scheme = url.scheme, scheme.contains("linkmoa") {
                            let folderIndex = Int(url.host ?? "0") ?? 0
                            let folderVC: SurfingFolderDetailViewController = DIContainer.shared.resolve(
                                argument: folderIndex
                            )
                            folderVC.homeNC = homeNC
                            homeNC.pushViewController(folderVC, animated: false)
                        }
                    } else { // [회원가입 화면] -> 회원이지만, 정보 입력이 필요한 상태
                        let registerNC: RegisterNavigationController = DIContainer.shared.resolve()
                        self.window?.rootViewController = registerNC
                    } 
                } else {
                    self.window?.rootViewController = loginVC
                }
            case .failure:
                self.window?.rootViewController = loginVC
            }
        }
    }
}
