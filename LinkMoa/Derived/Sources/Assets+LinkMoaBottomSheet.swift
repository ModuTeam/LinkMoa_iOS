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
public enum LinkMoaBottomSheetAsset {
  public static let backGray = LinkMoaBottomSheetColors(name: "BackGray")
  public static let darkBlue = LinkMoaBottomSheetColors(name: "DarkBlue")
  public static let group289 = LinkMoaBottomSheetImages(name: "Group 289")
  public static let group291 = LinkMoaBottomSheetImages(name: "Group 291")
  public static let backButton = LinkMoaBottomSheetImages(name: "backButton")
  public static let bottomArrow = LinkMoaBottomSheetImages(name: "bottomArrow")
  public static let bottomArrowWithLine = LinkMoaBottomSheetImages(name: "bottomArrowWithLine")
  public static let category0 = LinkMoaBottomSheetImages(name: "category_0")
  public static let category1 = LinkMoaBottomSheetImages(name: "category_1")
  public static let category2 = LinkMoaBottomSheetImages(name: "category_2")
  public static let category3 = LinkMoaBottomSheetImages(name: "category_3")
  public static let category4 = LinkMoaBottomSheetImages(name: "category_4")
  public static let createFolder = LinkMoaBottomSheetImages(name: "createFolder")
  public static let customXmark = LinkMoaBottomSheetImages(name: "customXmark")
  public static let customblueXmark = LinkMoaBottomSheetImages(name: "customblueXmark")
  public static let editDot = LinkMoaBottomSheetImages(name: "editDot")
  public static let editDotGrey = LinkMoaBottomSheetImages(name: "editDotGrey")
  public static let filter = LinkMoaBottomSheetImages(name: "filter")
  public static let garibi = LinkMoaBottomSheetImages(name: "garibi")
  public static let garibiWithSad = LinkMoaBottomSheetImages(name: "garibiWithSad")
  public static let garibiWithStar = LinkMoaBottomSheetImages(name: "garibiWithStar")
  public static let googleIcon = LinkMoaBottomSheetImages(name: "googleIcon")
  public static let lock = LinkMoaBottomSheetImages(name: "lock")
  public static let login = LinkMoaBottomSheetImages(name: "login")
  public static let modeEdit24px1 = LinkMoaBottomSheetImages(name: "mode_edit-24px 1")
  public static let naverIcon = LinkMoaBottomSheetImages(name: "naverIcon")
  public static let otter = LinkMoaBottomSheetImages(name: "otter")
  public static let person = LinkMoaBottomSheetImages(name: "person")
  public static let refresh = LinkMoaBottomSheetImages(name: "refresh")
  public static let search = LinkMoaBottomSheetImages(name: "search")
  public static let seashell = LinkMoaBottomSheetImages(name: "seashell")
  public static let seeshelCharacter = LinkMoaBottomSheetImages(name: "seeshelCharacter")
  public static let share = LinkMoaBottomSheetImages(name: "share")
  public static let splash1 = LinkMoaBottomSheetImages(name: "splash-1")
  public static let topArrow = LinkMoaBottomSheetImages(name: "topArrow")
  public static let whiteSeashell = LinkMoaBottomSheetImages(name: "whiteSeashell")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class LinkMoaBottomSheetColors {
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

public extension LinkMoaBottomSheetColors.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: LinkMoaBottomSheetColors) {
    let bundle = LinkMoaBottomSheetResources.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public struct LinkMoaBottomSheetImages {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = LinkMoaBottomSheetResources.bundle
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

public extension LinkMoaBottomSheetImages.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the LinkMoaBottomSheetImages.image property")
  convenience init?(asset: LinkMoaBottomSheetImages) {
    #if os(iOS) || os(tvOS)
    let bundle = LinkMoaBottomSheetResources.bundle
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
