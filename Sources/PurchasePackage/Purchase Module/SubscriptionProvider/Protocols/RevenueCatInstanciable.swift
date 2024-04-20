//
//  RevenueCatInstanciable.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/9/24.
//

import Foundation

/// Protocol defining the requirements for configuring the RevenueCat SDK.
/// This protocol ensures that any class conforming to it can initialize and configure
/// the RevenueCat SDK with specific parameters including API keys, debug options,
/// custom display settings for subscription types, and storage mechanisms.
public protocol PurchasesConfigurable {
  /// Configures the Package with necessary settings.
  /// - Parameters:
  ///   - apiKey: The API key required for subscription services.
  ///   - allowsRevenuCatDebug: Whether the package uses the debug setting for RevenueCat
  ///   - allowsIOSDebugLog: Whether the package logs key events using OSLog
  ///   - customisationData:  Customization options for subscription-related display elements.
  ///   - storage: The storage provider responsible for allowing for custom implementation or mocking.
  ///   - productProvider: Responsible for  listing the current available products/subscriptions in the App
  ///   - purchaseManager: Responsible for the purchasing and restoration of Subscriptions and IAP
  ///   - userProvider: Responsible for retreiving information about the User
  init(
    apiKey: String,
    allowsRevenuCatDebug: Bool,
    allowsIOSDebugLog: Bool,
    customisationData: SubscriptionCustomisation?,
    storage: UserDefaultsProvidable,
    productProvider: RevenueCatProductsProvidable,
    purchaseManager: RevenueCatPurchaseable,
    userProvider: RevenueCatUserProvidable
  )

  /// Logs out the current user from RevenueCat and clears any cached subscription data.
  func logOutAndClearCurrentData()
}
