//
//  SubscriptionPricingProviderTests.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/8/24.
//

@testable import PurchasePackage
import RevenueCat
import XCTest

final class SubscriptionPricingProviderTests: XCTestCase {
  private var mockUserDefaults: MockUserDefaults!
  private var pricingProvider: SubscriptionPricingProvider!

  // MARK: - LifeCycle

  override func setUp() {
    super.setUp()
    mockUserDefaults = MockUserDefaults()
    pricingProvider = SubscriptionPricingProvider(storage: mockUserDefaults)
  }

  // MARK: - Tests

  func testPricingTextForType() {
    let subscriptionType = ProductType.monthly
    let expectedPricingText = "$9.99/mo"
    let key = UserDefaultsKeys.priceSuffixKey(forType: subscriptionType)
    mockUserDefaults.set(expectedPricingText, forKey: key)
    let pricingText = pricingProvider.pricingText(forType: subscriptionType)
    XCTAssertEqual(
      pricingText,
      expectedPricingText,
      "The pricing text should be retrieved correctly from the mock user defaults"
    )
  }

  func testHeaderNameForType() {
    let subscriptionType = ProductType.annual
    let expectedHeaderName = "Annual Subscription"
    let key = UserDefaultsKeys.displayTextKey(forType: subscriptionType)
    mockUserDefaults.set(expectedHeaderName, forKey: key)
    let headerName = pricingProvider.headerName(forType: subscriptionType)
    XCTAssertEqual(
      headerName,
      expectedHeaderName,
      "The header name should be retrieved correctly from the mock user defaults"
    )
  }

  func testDefaultValues() {
    let subscriptionType = ProductType.lifetime

    let pricingText = pricingProvider.pricingText(forType: subscriptionType)
    XCTAssertEqual(pricingText, "Default Pricing", "Should return default pricing text when no value is set")

    let headerName = pricingProvider.headerName(forType: subscriptionType)
    XCTAssertEqual(headerName, "Default Name", "Should return default header name when no value is set")
  }
}
