//
//  UserPurchaseData.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/10/24.
//

import Foundation
import RevenueCat
import StoreKit

/// Represents user purchase data retrieved from RevenueCat.
public struct UserPurchaseData {
  /// StoreTransaction represents a single transaction from the App Store
  public var transaction: StoreTransaction?

  /// StoreProduct represents the product that was purchased, including details such as product ID, price, and
  /// description.
  public var product: StoreProduct?

  /// EntitlementInfo represents access levels or entitlements granted to the user based on their purchases.
  public var entitlements: [EntitlementInfo] = []

  /// NonSubscriptionTransaction represents purchases that are not subscriptions, such as consumable or non-consumable
  /// products.
  public var nonConsumablePurchases: [NonSubscriptionTransaction] = []

  /// A list of product identifiers for all active subscriptions the user currently has.
  public var activeSubscriptions: [String] = []

  /// The date of the original purchase. This is useful for calculating subscription durations, eligibility for offers,
  /// etc.
  public var dateOfPurchase: Date?

  // MARK: - Initialization

  /// Initializes with optional purchaserInfo,  for parsing the data relevant for subscription and IAP validation
  public init(purchaserInfo: CustomerInfo?) {
    // swiftlint:disable array_init
    self.entitlements = purchaserInfo?.entitlements.active.values.map { $0 } ?? []
    // swiftlint:enable array_init
    self.nonConsumablePurchases = Array(purchaserInfo?.nonSubscriptions ?? [])
    self.activeSubscriptions = Array(purchaserInfo?.activeSubscriptions ?? [])
    self.dateOfPurchase = purchaserInfo?.originalPurchaseDate
  }
}
