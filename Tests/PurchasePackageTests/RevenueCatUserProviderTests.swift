//
//  RevenueCatUserProviderTests.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/10/24.
//

import Foundation
@testable import PurchasePackage
import RevenueCat
import XCTest

final class RevenueCatUserProviderTests: XCTestCase {
  func testInititalisation() {
    let mockUserProvider = MockRevenueCatUserProvider(entitlementIdentifier: "ultimate", allowsIOSDebugLog: true)
    XCTAssertEqual(mockUserProvider.entitlementIdentifier, "ultimate")
    XCTAssertEqual(mockUserProvider.allowsIOSDebugLog, true)
  }

  func testFetchingCustomerInformationSuccess() async {
    let mockUserProvider = MockRevenueCatUserProvider(entitlementIdentifier: "ultimate", allowsIOSDebugLog: true)
    mockUserProvider.prepareMockCustomerInfo(MockCustomerInfo(activeSubscriptions: ["ultimate"]))

    do {
      try await mockUserProvider.getCustomerInformation()
    } catch {
      XCTFail("Fetching customer information should not fail in this scenario.")
    }
  }

  func testFetchingCustomerInformationFailure() async {
    let mockUserProvider = MockRevenueCatUserProvider(entitlementIdentifier: "ultimate", allowsIOSDebugLog: true)
    mockUserProvider.simulateFetchError = RevenueCatError.unableToGetCurrentUserInformation

    do {
      try await mockUserProvider.getCustomerInformation()
      XCTFail("Expected fetch to fail, but it succeeded.")
    } catch {
      XCTAssertEqual(error as? RevenueCatError, RevenueCatError.unableToGetCurrentUserInformation)
    }
  }

  func testIsAppleSubscriber() {
    let mockUserProvider = MockRevenueCatUserProvider(entitlementIdentifier: "ultimate", allowsIOSDebugLog: true)
    mockUserProvider.prepareMockCustomerInfo(MockCustomerInfo(activeSubscriptions: ["ultimate"]))
    XCTAssertTrue(mockUserProvider.isAppleSubscriber(), "User should be recognized as an Apple subscriber.")
  }
}
