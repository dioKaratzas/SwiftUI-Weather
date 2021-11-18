// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Add
  internal static let add = L10n.tr("Localizable", "add")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "cancel")
  /// Done
  internal static let done = L10n.tr("Localizable", "done")
  /// Feels like %@
  internal static func feelsLike(_ p1: Any) -> String {
    return L10n.tr("Localizable", "feels_like", String(describing: p1))
  }
  /// No Results
  internal static let noSearchResults = L10n.tr("Localizable", "no_search_results")
  /// Search for a location
  internal static let searchLocationPlaceholder = L10n.tr("Localizable", "search_location_placeholder")
  /// Weather
  internal static let weatherTitle = L10n.tr("Localizable", "weather_title")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
