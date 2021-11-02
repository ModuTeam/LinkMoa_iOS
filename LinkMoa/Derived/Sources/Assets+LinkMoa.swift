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
public enum LinkMoaAsset {
  public static let backGray = LinkMoaColors(name: "BackGray")
  public static let darkBlue = LinkMoaColors(name: "DarkBlue")
  public static let group289 = LinkMoaImages(name: "Group 289")
  public static let group291 = LinkMoaImages(name: "Group 291")
  public static let backButton = LinkMoaImages(name: "backButton")
  public static let bottomArrow = LinkMoaImages(name: "bottomArrow")
  public static let bottomArrowWithLine = LinkMoaImages(name: "bottomArrowWithLine")
  public static let category0 = LinkMoaImages(name: "category_0")
  public static let category1 = LinkMoaImages(name: "category_1")
  public static let category2 = LinkMoaImages(name: "category_2")
  public static let category3 = LinkMoaImages(name: "category_3")
  public static let category4 = LinkMoaImages(name: "category_4")
  public static let createFolder = LinkMoaImages(name: "createFolder")
  public static let customXmark = LinkMoaImages(name: "customXmark")
  public static let customblueXmark = LinkMoaImages(name: "customblueXmark")
  public static let editDot = LinkMoaImages(name: "editDot")
  public static let editDotGrey = LinkMoaImages(name: "editDotGrey")
  public static let filter = LinkMoaImages(name: "filter")
  public static let garibi = LinkMoaImages(name: "garibi")
  public static let garibiWithSad = LinkMoaImages(name: "garibiWithSad")
  public static let garibiWithStar = LinkMoaImages(name: "garibiWithStar")
  public static let googleIcon = LinkMoaImages(name: "googleIcon")
  public static let lock = LinkMoaImages(name: "lock")
  public static let login = LinkMoaImages(name: "login")
  public static let modeEdit24px1 = LinkMoaImages(name: "mode_edit-24px 1")
  public static let naverIcon = LinkMoaImages(name: "naverIcon")
  public static let otter = LinkMoaImages(name: "otter")
  public static let person = LinkMoaImages(name: "person")
  public static let refresh = LinkMoaImages(name: "refresh")
  public static let search = LinkMoaImages(name: "search")
  public static let seashell = LinkMoaImages(name: "seashell")
  public static let seeshelCharacter = LinkMoaImages(name: "seeshelCharacter")
  public static let share = LinkMoaImages(name: "share")
  public static let splash1 = LinkMoaImages(name: "splash-1")
  public static let topArrow = LinkMoaImages(name: "topArrow")
  public static let whiteSeashell = LinkMoaImages(name: "whiteSeashell")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class LinkMoaColors {
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

public extension LinkMoaColors.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: LinkMoaColors) {
    let bundle = LinkMoaResources.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public struct LinkMoaImages {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = LinkMoaResources.bundle
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

public extension LinkMoaImages.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the LinkMoaImages.image property")
  convenience init?(asset: LinkMoaImages) {
    #if os(iOS) || os(tvOS)
    let bundle = LinkMoaResources.bundle
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
