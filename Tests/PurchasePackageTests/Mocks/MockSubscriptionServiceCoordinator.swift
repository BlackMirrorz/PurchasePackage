//
//  MockSubscriptionServiceCoordinator.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/8/24.
//

import Foundation
@testable import PurchasePackage

class MockSubscriptionServiceCoordinator {
  static let shared = MockSubscriptionServiceCoordinator()

  private(set) var apiKey: String?

  private(set) var allowsRevenuCatDebug = false

  private(set) var allowsIOSDebugLog = false

  private(set) var customisationData: SubscriptionCustomisation?

  private(set) var storage: UserDefaultsProvidable = UserDefaults.standard

  private(set) var purchaseManager: RevenueCatPurchaseable?
  private(set) var productProvider: RevenueCatProductsProvidable?

  private(set) var userProvider: RevenueCatUserProvidable?

  lazy var subscriptionManager: SubscriptionProvider = {
    guard
      let apiKey = apiKey else {
      print(
        "SubscriptionServiceCoordinator must be configured with an API key before accessing SubscriptionManager."
      )
      fatalError("SubscriptionServiceCoordinator not configured with API key.")
    }

    return SubscriptionProvider(
      apiKey: apiKey,
      allowsRevenuCatDebug: self.allowsRevenuCatDebug,
      allowsIOSDebugLog: self.allowsIOSDebugLog,
      storage: self.storage,
      productProvider: self.productProvider!,
      purchaseManager: self.purchaseManager!,
      userProvider: self.userProvider!
    )
  }()

  // MARK: - Initialization

  private init() {}

  // MARK: - Configuration

  func configure(
    apiKey: String,
    allowsRevenuCatDebug: Bool,
    allowsIOSDebugLog: Bool,
    customisationData: SubscriptionCustomisation? = nil,
    storage: UserDefaultsProvidable,
    productProvider: RevenueCatProductsProvidable,
    purchaseManager: RevenueCatPurchaseable,
    userProvider: RevenueCatUserProvidable
  ) {
    self.apiKey = apiKey
    self.allowsIOSDebugLog = allowsIOSDebugLog
    self.allowsRevenuCatDebug = allowsRevenuCatDebug
    self.customisationData = customisationData
    self.storage = storage
    self.purchaseManager = purchaseManager
    self.userProvider = userProvider
    self.productProvider = productProvider
  }
}
