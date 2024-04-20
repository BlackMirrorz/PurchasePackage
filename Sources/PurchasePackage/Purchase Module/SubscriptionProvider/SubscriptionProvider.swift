//
//  SubscriptionProvider.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/8/24.
//

import Foundation
import RevenueCat

/// `SubscriptionManager` is responsible for managing subscription-related operations and interactions
/// with RevenueCat, a third-party service for handling in-app subscriptions.
public final class SubscriptionProvider: PurchasesConfigurable {
  /// Constants defining subscription types. These are used to map subscription details
  /// such as display names and price suffixes to their respective subscription types.
  private enum Constants: String {
    case annual
    case custom
    case lifetime
    case monthly
    case sixMonth
    case threeMonth
    case twoMonth
    case unknown
    case weekly
  }

  /// Storage provider used for persisting subscription-related data.
  private var storage: UserDefaultsProvidable?

  /// Product provider interfacing with RevenueCat to fetch and manage product information.
  public var productProvider: RevenueCatProductsProvidable!

  /// User proviider interfacing with RevenueCata to fetch details about the current user
  public var userProvider: RevenueCatUserProvidable!

  /// User proviider interfacing with RevenueCata to fetch details about the current user
  public var purchaseManager: RevenueCatPurchaseable!

  /// The terms and conditions data which contains the URL's for the Apps privacy policy and terms and conditions.
  public var termsAndConditionsData: TermsAndConditions

  /// Initializes a new instance of the SubscriptionManager with necessary configuration.
  /// - Parameters:
  ///   - apiKey: The API key required for subscription services.
  ///   - allowsRevenuCatDebug: Whether the package uses the debug setting for RevenueCat
  ///   - allowsIOSDebugLog: Whether the package logs key events using OSLog
  ///   - customisationData:  Customization options for subscription-related display elements.
  ///   - storage: The storage provider responsible for allowing for custom implementation or mocking.
  ///   - productProvider: Responsible for  listing the current available products/subscriptions in the App
  ///   - purchaseManager: Responsible for the purchasing and restoration of Subscriptions and IAP
  ///   - userProvider: Responsible for retreiving information about the User
  public init(
    apiKey: String,
    allowsRevenuCatDebug: Bool,
    allowsIOSDebugLog _: Bool,
    customisationData: SubscriptionCustomisation? = nil,
    storage: UserDefaultsProvidable,
    productProvider: RevenueCatProductsProvidable,
    purchaseManager: RevenueCatPurchaseable,
    userProvider: RevenueCatUserProvidable
  ) {
    self.storage = storage

    let customDisplayNames = customisationData?.headerNames ?? SubscriptionTypeHeaderNames()
    let customPriceSuffixes = customisationData?.priceSuffixes ?? SubscriptionTypeSuffixes()

    let subscriptionDetails: [String: (displayName: String, priceSuffix: String)] = [
      Constants.annual.rawValue: (customDisplayNames.annual, customPriceSuffixes.annual),
      Constants.custom.rawValue: (customDisplayNames.custom, customPriceSuffixes.custom),
      Constants.lifetime.rawValue: (customDisplayNames.lifetime, customPriceSuffixes.lifetime),
      Constants.monthly.rawValue: (customDisplayNames.monthly, customPriceSuffixes.monthly),
      Constants.sixMonth.rawValue: (customDisplayNames.sixMonth, customPriceSuffixes.sixMonth),
      Constants.threeMonth.rawValue: (customDisplayNames.threeMonth, customPriceSuffixes.threeMonth),
      Constants.twoMonth.rawValue: (customDisplayNames.twoMonth, customPriceSuffixes.twoMonth),
      Constants.unknown.rawValue: (customDisplayNames.unknown, customPriceSuffixes.unknown),
      Constants.weekly.rawValue: (customDisplayNames.weekly, customPriceSuffixes.weekly)
    ]

    for (type, details) in subscriptionDetails {
      let displayKey = UserDefaultsKeys.displayTextKey(forType: ProductType(rawValue: type)!)
      let suffixKey = UserDefaultsKeys.priceSuffixKey(forType: ProductType(rawValue: type)!)
      storage.set(details.displayName, forKey: displayKey)
      storage.set(details.priceSuffix, forKey: suffixKey)
    }

    self.termsAndConditionsData = customisationData?.termsAndConditions ?? TermsAndConditions()

    if allowsRevenuCatDebug { Purchases.logLevel = .debug }

    Purchases.configure(withAPIKey: apiKey)

    self.productProvider = productProvider

    self.userProvider = userProvider
    self.userProvider.configure()

    self.purchaseManager = purchaseManager
  }

  /// Logs out the current user from RevenueCat and clears any cached subscription data.
  public func logOutAndClearCurrentData() {

    userProvider.invalidateCustomerInfoCache()

    Task {
      try await Purchases.shared.logOut()
    }
  }
}
