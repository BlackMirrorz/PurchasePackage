//
//  RevenueCatUserProvider.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/9/24.
//

import Foundation
import RevenueCat

/// Class which provides the default implementation of  RevenueCatUserProvidable.
public final class RevenuCatUserProvider: NSObject, RevenueCatUserProvidable {

  @Published
  public var currentUserInfo: RevenueCat.CustomerInfo?

  public var allowsIOSDebugLog: Bool

  public var entitlementIdentifier: String?

  // MARK: - Initialization

  public init(entitlementIdentifier: String?, allowsIOSDebugLog: Bool) {
    self.allowsIOSDebugLog = allowsIOSDebugLog
    self.entitlementIdentifier = entitlementIdentifier
    super.init()
  }

  // MARK: - Callbacks

  public func configure() {
    Purchases.shared.delegate = self
    Task {
      try await self.getCustomerInformation()
    }
  }

  @discardableResult
  public func getCustomerInformation() async throws -> RevenueCat.CustomerInfo? {
    do {
      currentUserInfo = try await Purchases.shared.customerInfo()
      return currentUserInfo
    } catch {
      throw RevenueCatError.unableToGetCurrentUserInformation
    }
  }

  public func isAppleSubscriber() -> Bool {
    guard
      let currentUserInfo = currentUserInfo
    else {
      return false
    }

    if
      let entitlementIdentifier = entitlementIdentifier,
      let matchedEntitlement = currentUserInfo.entitlements[entitlementIdentifier] {
      return matchedEntitlement.isActive
    } else {
      return !currentUserInfo.entitlements.active.isEmpty
    }
  }

  public func invalidateCustomerInfoCache() {
    currentUserInfo = nil
  }
}

// MARK: - RevenueCat.PurchasesDelegate

extension RevenuCatUserProvider {
  public func purchases(_: Purchases, receivedUpdated purchaserInfo: CustomerInfo) {
    currentUserInfo = purchaserInfo
  }
}
