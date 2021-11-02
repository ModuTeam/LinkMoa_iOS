// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum LinkMoaKitAsset {
  public static let backGray = LinkMoaKitColors(name: "BackGray")
  public static let darkBlue = LinkMoaKitColors(name: "DarkBlue")
  public static let group289 = LinkMoaKitImages(name: "Group 289")
  public static let group291 = LinkMoaKitImages(name: "Group 291")
  public static let backButton = LinkMoaKitImages(name: "backButton")
  public static let bottomArrow = LinkMoaKitImages(name: "bottomArrow")
  public static let bottomArrowWithLine = LinkMoaKitImages(name: "bottomArrowWithLine")
  public static let category0 = LinkMoaKitImages(name: "category_0")
  public static let category1 = LinkMoaKitImages(name: "category_1")
  public static let category2 = LinkMoaKitImages(name: "category_2")
  public static let category3 = LinkMoaKitImages(name: "category_3")
  public static let category4 = LinkMoaKitImages(name: "category_4")
  public static let createFolder = LinkMoaKitImages(name: "createFolder")
  public static let customXmark = LinkMoaKitImages(name: "customXmark")
  public static let customblueXmark = LinkMoaKitImages(name: "customblueXmark")
  public static let editDot = LinkMoaKitImages(name: "editDot")
  public static let editDotGrey = LinkMoaKitImages(name: "editDotGrey")
  public static let filter = LinkMoaKitImages(name: "filter")
  public static let garibi = LinkMoaKitImages(name: "garibi")
  public static let garibiWithSad = LinkMoaKitImages(name: "garibiWithSad")
  public static let garibiWithStar = LinkMoaKitImages(name: "garibiWithStar")
  public static let googleIcon = LinkMoaKitImages(name: "googleIcon")
  public static let lock = LinkMoaKitImages(name: "lock")
  public static let login = LinkMoaKitImages(name: "login")
  public static let modeEdit24px1 = LinkMoaKitImages(name: "mode_edit-24px 1")
  public static let naverIcon = LinkMoaKitImages(name: "naverIcon")
  public static let otter = LinkMoaKitImages(name: "otter")
  public static let person = LinkMoaKitImages(name: "person")
  public static let refresh = LinkMoaKitImages(name: "refresh")
  public static let search = LinkMoaKitImages(name: "search")
  public static let seashell = LinkMoaKitImages(name: "seashell")
  public static let seeshelCharacter = LinkMoaKitImages(name: "seeshelCharacter")
  public static let share = LinkMoaKitImages(name: "share")
  public static let splash1 = LinkMoaKitImages(name: "splash-1")
  public static let topArrow = LinkMoaKitImages(name: "topArrow")
  public static let whiteSeashell = LinkMoaKitImages(name: "whiteSeashell")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class LinkMoaKitColors {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension LinkMoaKitColors.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: LinkMoaKitColors) {
    let bundle = LinkMoaKitResources.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public struct LinkMoaKitImages {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = LinkMoaKitResources.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

public extension LinkMoaKitImages.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the LinkMoaKitImages.image property")
  convenience init?(asset: LinkMoaKitImages) {
    #if os(iOS) || os(tvOS)
    let bundle = LinkMoaKitResources.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:enable all
// swiftformat:enable all
