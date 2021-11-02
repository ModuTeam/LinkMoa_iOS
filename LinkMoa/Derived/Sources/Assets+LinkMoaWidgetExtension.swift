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
public enum LinkMoaWidgetExtensionAsset {
  public static let backGray = LinkMoaWidgetExtensionColors(name: "BackGray")
  public static let darkBlue = LinkMoaWidgetExtensionColors(name: "DarkBlue")
  public static let group289 = LinkMoaWidgetExtensionImages(name: "Group 289")
  public static let group291 = LinkMoaWidgetExtensionImages(name: "Group 291")
  public static let backButton = LinkMoaWidgetExtensionImages(name: "backButton")
  public static let bottomArrow = LinkMoaWidgetExtensionImages(name: "bottomArrow")
  public static let bottomArrowWithLine = LinkMoaWidgetExtensionImages(name: "bottomArrowWithLine")
  public static let category0 = LinkMoaWidgetExtensionImages(name: "category_0")
  public static let category1 = LinkMoaWidgetExtensionImages(name: "category_1")
  public static let category2 = LinkMoaWidgetExtensionImages(name: "category_2")
  public static let category3 = LinkMoaWidgetExtensionImages(name: "category_3")
  public static let category4 = LinkMoaWidgetExtensionImages(name: "category_4")
  public static let createFolder = LinkMoaWidgetExtensionImages(name: "createFolder")
  public static let customXmark = LinkMoaWidgetExtensionImages(name: "customXmark")
  public static let customblueXmark = LinkMoaWidgetExtensionImages(name: "customblueXmark")
  public static let editDot = LinkMoaWidgetExtensionImages(name: "editDot")
  public static let editDotGrey = LinkMoaWidgetExtensionImages(name: "editDotGrey")
  public static let filter = LinkMoaWidgetExtensionImages(name: "filter")
  public static let garibi = LinkMoaWidgetExtensionImages(name: "garibi")
  public static let garibiWithSad = LinkMoaWidgetExtensionImages(name: "garibiWithSad")
  public static let garibiWithStar = LinkMoaWidgetExtensionImages(name: "garibiWithStar")
  public static let googleIcon = LinkMoaWidgetExtensionImages(name: "googleIcon")
  public static let lock = LinkMoaWidgetExtensionImages(name: "lock")
  public static let login = LinkMoaWidgetExtensionImages(name: "login")
  public static let modeEdit24px1 = LinkMoaWidgetExtensionImages(name: "mode_edit-24px 1")
  public static let naverIcon = LinkMoaWidgetExtensionImages(name: "naverIcon")
  public static let otter = LinkMoaWidgetExtensionImages(name: "otter")
  public static let person = LinkMoaWidgetExtensionImages(name: "person")
  public static let refresh = LinkMoaWidgetExtensionImages(name: "refresh")
  public static let search = LinkMoaWidgetExtensionImages(name: "search")
  public static let seashell = LinkMoaWidgetExtensionImages(name: "seashell")
  public static let seeshelCharacter = LinkMoaWidgetExtensionImages(name: "seeshelCharacter")
  public static let share = LinkMoaWidgetExtensionImages(name: "share")
  public static let splash1 = LinkMoaWidgetExtensionImages(name: "splash-1")
  public static let topArrow = LinkMoaWidgetExtensionImages(name: "topArrow")
  public static let whiteSeashell = LinkMoaWidgetExtensionImages(name: "whiteSeashell")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class LinkMoaWidgetExtensionColors {
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

public extension LinkMoaWidgetExtensionColors.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: LinkMoaWidgetExtensionColors) {
    let bundle = LinkMoaWidgetExtensionResources.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public struct LinkMoaWidgetExtensionImages {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = LinkMoaWidgetExtensionResources.bundle
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

public extension LinkMoaWidgetExtensionImages.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the LinkMoaWidgetExtensionImages.image property")
  convenience init?(asset: LinkMoaWidgetExtensionImages) {
    #if os(iOS) || os(tvOS)
    let bundle = LinkMoaWidgetExtensionResources.bundle
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
