//
//  RevenueCatErrorTests.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/11/24.
//

@testable import PurchasePackage
import XCTest

class RevenueCatErrorTests: XCTestCase {
  func testErrorMessages() {
    XCTAssertEqual(RevenueCatError.offeringsNotFound.message, "No subscriptions or IAP available for this app.")
    XCTAssertEqual(
      RevenueCatError.unableToGetCurrentUserInformation.message,
      "Sorry we were unable to get information for the current user."
    )
    XCTAssertEqual(
      RevenueCatError.userDidCancelPurchase.message,
      "You have cancelled the current transaction.\nPlease try again."
    )
    XCTAssertEqual(
      RevenueCatError.noSubscriptionMade.message,
      "Sorry we were unable to process your transaction.\nPlease try again"
    )
    XCTAssertEqual(
      RevenueCatError.subscriptionError("Error").message,
      "Sorry we were unable to restore your purchases.\nPlease try again"
    )
    XCTAssertEqual(
      RevenueCatError.restoreError("Error").message,
      "Sorry we were unable to restore your purchases.\nPlease try again"
    )
    XCTAssertEqual(
      RevenueCatError.unableToRestoreSubscription.message,
      "Sorry we were unable to restore your purchases.\nPlease try again"
    )
  }
}
