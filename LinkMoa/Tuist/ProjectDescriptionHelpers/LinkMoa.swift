//
//  LinkMoa.swift
//  ProjectDescriptionHelpers
//
//  Created by won heo on 2021/09/24.
//

import ProjectDescription

public enum LinkMoa: String, CaseIterable {
    // FrameWorks
    case kit = "LinkMoaKit"
    case core = "LinkMoaCore"
    case bottomSheet = "LinkMoaBottomSheet"
    // App Extension
    case share = "LinkMoaShareExtension"
    case widget = "LinkMoaWidgetExtension"
    // App
    case app = "LinkMoa"
    // Unit Tests
    case kitTests = "LinkMoaKitTests"
    case coreTests = "LinkMoaCoreTests"
    case bottomSheetTests = "LinkMoaBottomSheetTests"
    
    public static let appName = "LinkMoa"
    public static let bundleID = "com.makeus.linkMoa"
    
    public var name: String {
        return self.rawValue
    }
    
    public var platform: ProjectDescription.Platform {
        return .iOS
    }
    
    public var product: ProjectDescription.Product {
        switch self {
        case .app:
            return .app
        case .share, .widget:
            return .appExtension
        case .kitTests, .coreTests, .bottomSheetTests:
            return .unitTests
        default:
            return .framework
        }
    }
    
    public var bundleId: String {
        switch self {
        case .app:
            return LinkMoa.bundleID
        default:
            return LinkMoa.bundleID + "." + self.name
        }
    }
    
    public var deploymentTarget: ProjectDescription.DeploymentTarget? {
        switch self {
        case .widget:
            return .iOS(targetVersion: "14.0", devices: [.iphone])
        default:
            return .iOS(targetVersion: "13.0", devices: [.iphone])
        }
    }
    
    public var infoPlist: ProjectDescription.InfoPlist {
        switch self {
        case .app, .share, .widget:
            return "Targets/\(self.name)/Sources/Info.plist"
        default:
            return .default
        }
    }
    
    public var sources: ProjectDescription.SourceFilesList {
        switch self {
        case .share:
            return [
                "Targets/\(self.name)/Sources/**",
                "Targets/\(LinkMoa.app.name)/Sources/Link/**",
            ]
        default:
            return "Targets/\(self.name)/Sources/**"
        }
    }
    
    public var resources: ProjectDescription.ResourceFileElements? {
        switch self {
        case .app, .bottomSheet, .widget:
            return [
                "Targets/\(self.name)/Resources/**",
                "Targets/\(LinkMoa.kit.name)/Resources/Assets/**"
            ]
        case .share:
            return [
                "Targets/\(self.name)/Resources/**",
                "Targets/\(LinkMoa.kit.name)/Resources/Assets/**",
                "Targets/\(LinkMoa.app.name)/Resources/Link/**"
            ]
        case .kit, .kitTests, .coreTests, .bottomSheetTests:
            return "Targets/\(self.name)/Resources/**"
        default:
            return nil
        }
    }
    
    public var entitlements: ProjectDescription.Path? {
        switch self {
        case .app, .share, .widget:
            return "Targets/\(self.name)/Sources/\(self.name).entitlements"
        default:
            return nil
        }
    }
    
    public var dependencies: [ProjectDescription.TargetDependency] {
        switch self {
        case .app:
            return [
                .target(name: LinkMoa.kit.name),
                .target(name: LinkMoa.core.name),
                .target(name: LinkMoa.bottomSheet.name),
                .target(name: LinkMoa.share.name),
                .target(name: LinkMoa.widget.name)
            ]
        case .share:
            return [
                .target(name: LinkMoa.kit.name),
                .target(name: LinkMoa.core.name),
                .target(name: LinkMoa.bottomSheet.name)
            ]
        case .widget, .bottomSheet:
            return [
                .target(name: LinkMoa.kit.name),
                .target(name: LinkMoa.core.name),
            ]
        case .core:
            return []
        case .kitTests:
            return [
                .target(name: LinkMoa.kit.name)
            ]
        case .coreTests:
            return [
                .target(name: LinkMoa.core.name)
            ]
        case .bottomSheetTests:
            return [
                .target(name: LinkMoa.kit.name),
                .target(name: LinkMoa.core.name),
                .target(name: LinkMoa.bottomSheet.name)
            ]
        default:
            return []
        }
    }
}
