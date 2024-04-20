//
//  AppManageable.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 3/23/24.
//

import Foundation
import NetworkingLayer

/**
 Responsible for configuring the application's subscription and user management functionalities.
 This protocol defines the essential properties and methods required for managing user subscriptions, administrative access, and app configuration settings related to RevenueCat and custom data storage implementations.
 */
public protocol AppManaegable {

  /// The BundleID of the App. Defaults to Bundle.main.bundleIdentifier
  var bundleID: String { get set }

  /// Value determining if a User has full unlimited access to the App.
  ///
  /// Returns  true if:
  /// - The User is a paid subscriber via the App.
  ///
  var isUltimateUser: Bool { get }

  /// Whether the User has a paid Apple Subscription
  var isAppleSubscriber: Bool { get }
  /// Logs the User out and resets the Purchase Provider
  func logout()

  // swiftlint:disable function_parameter_count

  /// Initializes the Manager
  /// - Parameters:
  ///   - apiKey: The API key required for subscription services.
  ///   - bundleID: The Bundle Identifier of the App. Uses the defalt BundleID by default. Change thiis ONLY to mock access levels etc.
  ///   - requiredSubscriptionForApp: An optional access level required to use the App. Defaults to nil meaning any User with a paid subscription can access the app.
  ///   - allowsRevenuCatDebug: Whether the package uses the debug setting for RevenueCat.
  ///   - allowsIOSDebugLog: allowsIOSDebugLog: Whether the package logs key events using OSLog.
  ///   - customisationData: Customization options for subscription-related display elements.
  ///   - storage: The storage provider responsible for allowing for custom implementation or mocking.
  ///   - secureStorage: The secure storage provider responsible for allowing for custom implementation or mocking. Ensure this is the same  as the one used in the `LoginViewModel`.
  ///   - productProvider: Provider responsible for  listing the current available products/subscriptions in the App
  ///   - purchaseManager: Manager responsible for the purchasing and restoration of Subscriptions and IAP
  ///   - userProvider: Responsible for providing  information about the User
  func configure(
    apiKey: String,
    bundleID: String,
    allowsRevenuCatDebug: Bool,
    allowsIOSDebugLog: Bool,
    customisationData: SubscriptionCustomisation?,
    storage: UserDefaultsProvidable,
    secureStorageService: SecureStorageService,
    productProvider: RevenueCatProductsProvidable,
    purchaseManager: RevenueCatPurchaseable,
    userProvider: RevenueCatUserProvidable
  )
  // swiftlint:enable function_parameter_count
}
