//
//  SubscriptionPricingProvider.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/8/24.
//

import Foundation

/// Class providing subscription pricing and display text functionality, utilizing a UserDefaultsProvidable for storage.
public final class SubscriptionPricingProvider: SubscriptionPricingProvidable {
  private var storage: UserDefaultsProvidable

  /// Initializes a new instance with the specified storage mechanism.
  /// - Parameter storage: The storage mechanism conforming to UserDefaultsProvidable.
  public init(storage: UserDefaultsProvidable = UserDefaults.standard) {
    self.storage = storage
  }

  /// Retrieves the pricing text for a given subscription type.
  /// - Parameter type: The subscription type for which to retrieve the pricing text.
  /// - Returns: The pricing text associated with the subscription type, or a default string if not found.
  public func pricingText(forType type: ProductType) -> String {
    let key = UserDefaultsKeys.priceSuffixKey(forType: type)
    return storage.string(forKey: key) ?? "Default Pricing"
  }

  /// Retrieves the display name for a given subscription type.
  /// - Parameter type: The subscription type for which to retrieve the display name.
  /// - Returns: The display name associated with the subscription type, or a default string if not found.
  public func headerName(forType type: ProductType) -> String {
    let key = UserDefaultsKeys.displayTextKey(forType: type)
    return storage.string(forKey: key) ?? "Default Name"
  }
}

// MARK: - SubscriptionPricingProvidable

/// Protocol defining the functionality for providing subscription pricing and display names.
public protocol SubscriptionPricingProvidable {
  /// Retrieves the display name for a specific subscription type.
  /// - Parameter type: The subscription type.
  /// - Returns: The display name for the type.
  func headerName(forType type: ProductType) -> String

  /// Retrieves the pricing text for a specific subscription type.
  /// - Parameter type: The subscription type.
  /// - Returns: The pricing text for the type.
  func pricingText(forType type: ProductType) -> String
}
