//
//  ProductInfoConstructable.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/9/24.
//

import Foundation
import RevenueCat
import StoreKit

/// Protocol for configuring the information about a SubscriptionPackage or IAP.
protocol ProductInfoConstructable {
  /// Unique identifier for the product/
  var id: String { get }

  /// The type of the product, distinguishing between various forms such as subscription, non-renewing subscription, or
  /// non-subscription.
  var type: ProductType { get }

  /// The identifier for the product, typically matching the SKU or product ID as defined in the app store.
  var identifier: String { get }

  /// The `StoreProduct` from RevenueCat, representing detailed information about the product fetched from the app
  /// store, including metadata like title, description, and price.
  var product: RevenueCat.StoreProduct { get }

  /// The `Package` from RevenueCat, representing a specific offering for a product, which may include different
  /// subscription durations or product bundles.
  var package: RevenueCat.Package { get }

  /// The price of the product as an `NSDecimalNumber`, allowing for precise arithmetic on the product price.
  var price: NSDecimalNumber { get }

  /// The localized price string, formatted according to the user's locale, which may include the currency symbol and
  /// appropriate formatting.
  var localizedPrice: String? { get }

  /// The product identifier, typically the same as `identifier` but explicitly focusing on the product's SKU or ID as
  /// defined in the store.
  var productIdentifier: String { get }

  /// A human-readable name for the subscription, designed for display purposes to enhance user understanding and
  /// readability.
  var subscriptionDisplayName: String { get }

  /// Text designed for display that succinctly presents the pricing information, potentially including duration, free
  /// trial availability, and other relevant details.
  var pricingDisplayText: String { get }

  /// A string that provides a detailed description of the product for debugging purposes, including all relevant
  /// information that might aid in troubleshooting.
  var debugDescription: String { get }

  /// A Boolean indicating whether the product is eligible for a trial period, allowing users to try before subscribing.
  var isEligibleForTrial: Bool { get }

  /// Message to be displayed if a Free Trial is available.
  var freeTrialMessageText: String? { get set }

  /// The required terms and conditions of the Subscription or IAP.
  var subscriptionMessage: String { get set }

  /// Method to set the trial eligibility status. This might be used to update the product's trial eligibility based  on certain conditions or user actions.
  mutating func setIsElibleForTrial()

  /// Method to override the default App Name. This should only be used for mocking.
  mutating func setAppName(_ appName: String)

  /// Method to override the Free Trial message if applicable.. This should only be used for mocking.
  mutating func setFreeTrialMessgeText(_ text: String)

  /// Initializes a new instance of a conforming type with the specified package, display name, and pricing text.
  /// This initializer ensures that all necessary information for representing a subscription package or IAP is provided
  /// upon creation.
  /// - Parameters:
  ///   - package: The `Package` from RevenueCat that includes detailed information about the offering.
  ///   - subscriptionDisplayName: A human-readable name for the subscription.
  ///   - pricingText: Text representing the pricing information in a user-friendly manner.
  init(package: RevenueCat.Package, subscriptionDisplayName: String, pricingText: String)
}
