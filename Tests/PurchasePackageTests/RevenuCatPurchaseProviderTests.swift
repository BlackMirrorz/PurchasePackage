//
//  RevenuCatPurchaseProviderTests.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/10/24.
//

@testable import PurchasePackage
import RevenueCat
import StoreKit
import XCTest

final class RevenuCatPurchaseProviderTests: XCTestCase {

  // MARK: - Subscriptions

  func testSubscriptionTransactionCancelledThrowsError() async {
    let provider = generateMockProvider(didCancel: true, activeSubscriptions: [])

    do {
      try await provider.purchasePackage(productInformation: provider.mockProductInformation)
      XCTFail("Expected userDidCancelPurchase error to be thrown, but the operation did not throw")
    } catch let error as RevenueCatError {
      XCTAssertEqual(
        error,
        RevenueCatError.userDidCancelPurchase,
        "Expected userDidCancelPurchase error, but received a different error"
      )
    } catch {
      XCTFail("Expected RevenueCatError.userDidCancelPurchase, but received an unexpected error type")
    }
  }

  func testSubscriptionTransactionButNoSubscriptionReturnedThrowsError() async {
    let provider = generateMockProvider(didCancel: false, activeSubscriptions: [])

    do {
      try await provider.purchasePackage(productInformation: provider.mockProductInformation)
      XCTFail("Expected userDidCancelPurchase error to be thrown, but the operation did not throw")
    } catch let error as RevenueCatError {
      XCTAssertEqual(
        error,
        RevenueCatError.noSubscriptionMade,
        "Expected noSubscriptionMade error, but received a different error"
      )
    } catch {
      XCTFail("Expected RevenueCatError.userDidCancelPurchase, but received an unexpected error type")
    }
  }

  func testSubscriptionIsSuccesful() async {
    let provider = generateMockProvider(didCancel: false, activeSubscriptions: ["co.pongo.bongo.annual"])

    do {
      try await provider.purchasePackage(productInformation: provider.mockProductInformation)
    } catch {
      XCTFail("Subscrption should have succeeded")
    }
  }

  // MARK: - Restoration

  func testRestorationTransactionButNoSubscriptionReturnedThrowsError() async {
    let provider = generateMockProvider(didCancel: false, activeSubscriptions: [])

    do {
      try await provider.restorePurchases()
      XCTFail("Expected userDidCancelPurchase error to be thrown, but the operation did not throw")
    } catch let error as RevenueCatError {
      XCTAssertEqual(
        error,
        RevenueCatError.unableToRestoreSubscription,
        "Expected unableToRestoreSubscription error, but received a different error"
      )
    } catch {
      XCTFail("Expected RevenueCatError.userDidCancelPurchase, but received an unexpected error type")
    }
  }

  func testRestorationIsSuccesful() async {
    let provider = generateMockProvider(didCancel: false, activeSubscriptions: ["co.pongo.bongo.annual"])
    do {
      try await provider.restorePurchases()
    } catch {
      XCTFail("Purchases Restore should have succeeded")
    }
  }
}
