//
//  RevenueCatUserProvidable.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/9/24.
//

import Foundation
import RevenueCat

/// Protocol responsible for retrieving information about the User in context with RevenueCat services.
/// This protocol extends PackageDebuggable for debugging purposes and conforms to RevenueCat.PurchasesDelegate
/// to handle updates or changes in purchase information directly from RevenueCat.
public protocol RevenueCatUserProvidable: PackageDebuggable, RevenueCat.PurchasesDelegate {
  /// The identifier for the entitlement which unlocks premium content within the app.
  /// This is used to determine access rights based on user purchases or subscriptions.
  var entitlementIdentifier: String? { get }

  /// Asynchronously retrieves the current customer's information from RevenueCat.
  /// This includes subscriptions, purchases, and any entitlements associated with the user.
  /// - Returns: An optional RevenueCat.CustomerInfo object containing the user's purchase history and entitlements.
  /// - Throws: An error if there's an issue fetching the customer information, such as a network error or configuration
  /// issue.
  func getCustomerInformation() async throws -> RevenueCat.CustomerInfo?

  /// Determines if the current user has a valid entitlement and active subscription.
  /// This is crucial for gating content or features that require a subscription.
  /// - Returns: A Boolean value indicating whether the user is currently subscribed through Apple's In-App Purchase.
  func isAppleSubscriber() -> Bool

  /// Sets up the RevenueCat.PurchasesDelegate and synchronizes the RevenueCat.CustomerInfo.
  /// This method is typically called during app initialization or when the user's purchase information needs to be
  /// refreshed.
  /// It ensures that the app's state is up-to-date with the latest purchase and subscription information from
  /// RevenueCat.
  func configure()

  func invalidateCustomerInfoCache()

  /// Initializes a new instance of a conforming type with an optional entitlement identifier and a debug logging
  /// option.
  /// - Parameters:
  ///   - entitlementIdentifier: The identifier for the specific entitlement that unlocks app content, if applicable.
  ///   - allowsIOSDebugLog: A Boolean flag indicating whether iOS debugging logs should be enabled, useful for
  /// development and troubleshooting.
  init(entitlementIdentifier: String?, allowsIOSDebugLog: Bool)
}
