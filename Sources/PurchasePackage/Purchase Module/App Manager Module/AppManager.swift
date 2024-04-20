//
//  AppManager.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 3/23/24.
//

import Foundation
import NetworkingLayer

/**
 Singleton which creates  the `SubscriptionProvider` which is user for managing subscriptions and IAP;s.

 Utilized by the default `Subscription Client`.

 It class implements the `AppManageable` protocol, centralizing the logic required to manage subscriptions and user access within the app.

 It leverages RevenueCat for subscription services and secure storage for persisting user credentials, and custom logic to determine user access levels.`
 */
public class AppManager: AppManaegable {

  public static let shared = AppManager()

  public var secureStorageService: SecureStorageService!
  public var bundleID: String = Bundle.bundleId ?? ""
  public var subscriptionManager: SubscriptionProvider!

  // MARK: - Initialization

  private init() {}

  // MARK: - Configuration

  public func configure(
    apiKey: String,
    bundleID: String = Bundle.bundleId ?? "",
    allowsRevenuCatDebug: Bool = false,
    allowsIOSDebugLog: Bool = true,
    customisationData: SubscriptionCustomisation? = nil,
    storage: UserDefaultsProvidable = UserDefaults.standard,
    secureStorageService: SecureStorageService = KeyChainSecureStorageProvider.shared,
    productProvider: RevenueCatProductsProvidable = RevenuCatProductProvider(
      displayNameService: SubscriptionPricingProvider(storage: UserDefaults.standard),
      allowsIOSDebugLog: true
    ),
    purchaseManager: RevenueCatPurchaseable = RevenuCatPurchaseProvider(allowsIOSDebugLog: true),
    userProvider: RevenueCatUserProvidable = RevenuCatUserProvider(
      entitlementIdentifier: "ultimate",
      allowsIOSDebugLog: true
    )
  ) {

    self.bundleID = bundleID

    subscriptionManager = SubscriptionProvider(
      apiKey: apiKey,
      allowsRevenuCatDebug: allowsRevenuCatDebug,
      allowsIOSDebugLog: allowsIOSDebugLog,
      customisationData: customisationData,
      storage: storage,
      productProvider: productProvider,
      purchaseManager: purchaseManager,
      userProvider: userProvider
    )

    self.secureStorageService = secureStorageService
  }

  public var isUltimateUser: Bool {
    isAppleSubscriber
  }

  public var isAppleSubscriber: Bool {
    guard let userProvider = subscriptionManager.userProvider else { return false }
    return userProvider.isAppleSubscriber()
  }

  // MARK: - LogOut

  public func logout() {
    secureStorageService.deleteAllItems()
    subscriptionManager.logOutAndClearCurrentData()
  }
}
