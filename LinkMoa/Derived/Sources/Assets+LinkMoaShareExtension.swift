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
public enum LinkMoaShareExtensionAsset {
  public static let backGray = LinkMoaShareExtensionColors(name: "BackGray")
  public static let darkBlue = LinkMoaShareExtensionColors(name: "DarkBlue")
  public static let group289 = LinkMoaShareExtensionImages(name: "Group 289")
  public static let group291 = LinkMoaShareExtensionImages(name: "Group 291")
  public static let backButton = LinkMoaShareExtensionImages(name: "backButton")
  public static let bottomArrow = LinkMoaShareExtensionImages(name: "bottomArrow")
  public static let bottomArrowWithLine = LinkMoaShareExtensionImages(name: "bottomArrowWithLine")
  public static let category0 = LinkMoaShareExtensionImages(name: "category_0")
  public static let category1 = LinkMoaShareExtensionImages(name: "category_1")
  public static let category2 = LinkMoaShareExtensionImages(name: "category_2")
  public static let category3 = LinkMoaShareExtensionImages(name: "category_3")
  public static let category4 = LinkMoaShareExtensionImages(name: "category_4")
  public static let createFolder = LinkMoaShareExtensionImages(name: "createFolder")
  public static let customXmark = LinkMoaShareExtensionImages(name: "customXmark")
  public static let customblueXmark = LinkMoaShareExtensionImages(name: "customblueXmark")
  public static let editDot = LinkMoaShareExtensionImages(name: "editDot")
  public static let editDotGrey = LinkMoaShareExtensionImages(name: "editDotGrey")
  public static let filter = LinkMoaShareExtensionImages(name: "filter")
  public static let garibi = LinkMoaShareExtensionImages(name: "garibi")
  public static let garibiWithSad = LinkMoaShareExtensionImages(name: "garibiWithSad")
  public static let garibiWithStar = LinkMoaShareExtensionImages(name: "garibiWithStar")
  public static let googleIcon = LinkMoaShareExtensionImages(name: "googleIcon")
  public static let lock = LinkMoaShareExtensionImages(name: "lock")
  public static let login = LinkMoaShareExtensionImages(name: "login")
  public static let modeEdit24px1 = LinkMoaShareExtensionImages(name: "mode_edit-24px 1")
  public static let naverIcon = LinkMoaShareExtensionImages(name: "naverIcon")
  public static let otter = LinkMoaShareExtensionImages(name: "otter")
  public static let person = LinkMoaShareExtensionImages(name: "person")
  public static let refresh = LinkMoaShareExtensionImages(name: "refresh")
  public static let search = LinkMoaShareExtensionImages(name: "search")
  public static let seashell = LinkMoaShareExtensionImages(name: "seashell")
  public static let seeshelCharacter = LinkMoaShareExtensionImages(name: "seeshelCharacter")
  public static let share = LinkMoaShareExtensionImages(name: "share")
  public static let splash1 = LinkMoaShareExtensionImages(name: "splash-1")
  public static let topArrow = LinkMoaShareExtensionImages(name: "topArrow")
  public static let whiteSeashell = LinkMoaShareExtensionImages(name: "whiteSeashell")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class LinkMoaShareExtensionColors {
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

public extension LinkMoaShareExtensionColors.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: LinkMoaShareExtensionColors) {
    let bundle = LinkMoaShareExtensionResources.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public struct LinkMoaShareExtensionImages {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = LinkMoaShareExtensionResources.bundle
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

public extension LinkMoaShareExtensionImages.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the LinkMoaShareExtensionImages.image property")
  convenience init?(asset: LinkMoaShareExtensionImages) {
    #if os(iOS) || os(tvOS)
    let bundle = LinkMoaShareExtensionResources.bundle
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
