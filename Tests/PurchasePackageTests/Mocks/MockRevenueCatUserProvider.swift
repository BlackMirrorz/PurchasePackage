//
//  MockRevenueCatUserProvider.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/10/24.
//

import Foundation
@testable import PurchasePackage
import RevenueCat
import XCTest

class MockRevenueCatUserProvider: NSObject, RevenueCatUserProvidable {
  var currentUserInfo: RevenueCat.CustomerInfo?
  var entitlementIdentifier: String?
  var allowsIOSDebugLog: Bool
  var mockCustomerInfo: MockCustomerInfo?
  var simulateFetchError: RevenueCatError?

  // MARK: - Initialization

  required init(entitlementIdentifier: String?, allowsIOSDebugLog: Bool = true) {
    self.entitlementIdentifier = entitlementIdentifier
    self.allowsIOSDebugLog = allowsIOSDebugLog
  }

  // MARK: - Callbacks

  func configure() {}

  func prepareMockCustomerInfo(_ mockCustomerInfo: MockCustomerInfo) {
    self.mockCustomerInfo = mockCustomerInfo
  }

  @discardableResult
  func getCustomerInformation() async throws -> RevenueCat.CustomerInfo? {
    if let error = simulateFetchError {
      throw error
    }
    return nil
  }

  func isAppleSubscriber() -> Bool {
    guard let mockCustomerInfo = mockCustomerInfo else { return false }
    return !mockCustomerInfo.activeSubscriptions.isEmpty
  }

  func invalidateCustomerInfoCache() {}
}
