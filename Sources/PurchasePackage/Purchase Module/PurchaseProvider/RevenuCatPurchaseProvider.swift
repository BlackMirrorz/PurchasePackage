//
//  RevenuCatPurchaseProvider.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/10/24.
//

import Foundation
import RevenueCat

/// Default Implementation of RevenueCatPurchaseable for handling purchase operations.
public final class RevenuCatPurchaseProvider: RevenueCatPurchaseable {

  public var allowsIOSDebugLog: Bool

  // MARK: - Initialization

  public init(allowsIOSDebugLog: Bool) {
    self.allowsIOSDebugLog = allowsIOSDebugLog
  }
}

// MARK: - Purchases

extension RevenuCatPurchaseProvider {

  public func purchasePackage(productInformation: ProductInformation) async throws {
    let package = productInformation.package

    do {
      let result = try await Purchases.shared.purchase(package: package)

      switch result.userCancelled {
      case true:
        throw RevenueCatError.userDidCancelPurchase
      case false:
        let purchaseData = UserPurchaseData(purchaserInfo: result.customerInfo)

        guard !purchaseData.activeSubscriptions.isEmpty else {
          throw RevenueCatError.noSubscriptionMade
        }
      }
    }
  }

  public func restorePurchases() async throws {
    do {
      let result = try await Purchases.shared.restorePurchases()

      let purchaseData = UserPurchaseData(purchaserInfo: result)

      guard !purchaseData.activeSubscriptions.isEmpty else {
        throw RevenueCatError.unableToRestoreSubscription
      }

    } catch {
      throw RevenueCatError.restoreError(error.localizedDescription)
    }
  }
}
