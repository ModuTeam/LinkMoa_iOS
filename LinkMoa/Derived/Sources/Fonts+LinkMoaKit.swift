// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

#if os(OSX)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
public enum LinkMoaKitFontFamily {
  public enum NotoSansKR {
    public static let medium = LinkMoaKitFontConvertible(name: "NotoSansKR-Medium", family: "Noto Sans KR", path: "NotoSansKR-Medium.otf")
    public static let regular = LinkMoaKitFontConvertible(name: "NotoSansKR-Regular", family: "Noto Sans KR", path: "NotoSansKR-Regular.otf")
    public static let all: [LinkMoaKitFontConvertible] = [medium, regular]
  }
  public enum Poppins {
    public static let light = LinkMoaKitFontConvertible(name: "Poppins-Light", family: "Poppins", path: "Poppins-Light.ttf")
    public static let all: [LinkMoaKitFontConvertible] = [light]
  }
  public static let allCustomFonts: [LinkMoaKitFontConvertible] = [NotoSansKR.all, Poppins.all].flatMap { $0 }
  public static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

public struct LinkMoaKitFontConvertible {
  public let name: String
  public let family: String
  public let path: String

  #if os(OSX)
  public typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Font = UIFont
  #endif

  public func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  public func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

public extension LinkMoaKitFontConvertible.Font {
  convenience init?(font: LinkMoaKitFontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(OSX)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
// swiftlint:enable all
// swiftformat:enable all
