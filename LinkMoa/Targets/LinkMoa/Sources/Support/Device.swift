//
//  Device.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/26.
//

import UIKit

public struct Device {
    // MARK: 노치 디자인인지 아닌지
    public static var isNotch: Bool {
        return Double(UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? -1) > 0
    }
    
    // MARK: 상태바 높이
    public static var statusBarHeight: CGFloat {
        return UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    // MARK: 네비게이션 바 높이
    public static var navigationBarHeight: CGFloat {
        return UINavigationController().navigationBar.frame.height
    }
    
    // MARK: 탭 바 높이
    public static var tabBarHeight: CGFloat {
        return UITabBarController().tabBar.frame.height
    }
    
    // MARK: 디바이스의 위쪽 여백 (Safe Area 위쪽 여백)
    // ** 위쪽 여백의 전체 높이 : topInset + statusBarHeight + navigationBarHeight(존재하는 경우) **
    public static var topInset: CGFloat {
        return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    }
    
    // MARK: 디바이스의 아래쪽 여백 (Safe Area 아래쪽 여백)
    // ** 아래쪽 여백의 전체 높이 : bottomInset + tabBarHeight(존재하는 경우) **
    public static var bottomInset: CGFloat {
        return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    }
}
