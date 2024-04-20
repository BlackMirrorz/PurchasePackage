//
//  SubscriptionManagerTests.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/8/24.
//

@testable import PurchasePackage
import RevenueCat
import StoreKit
import XCTest

final class SubscriptionManagerTests: XCTestCase {
  private var mockUserDefaults: MockUserDefaults!
  private var pricingProvider: SubscriptionPricingProvider!
  private var productProvider: MockRevenuCatProductProvider!
  private var purchaseProvider: MockRevenuCatPurchaseProvider!
  private var userProvider: MockRevenueCatUserProvider!
  private let coordinator = MockSubscriptionServiceCoordinator.shared

  // MARK: - LifeCycle

  override func setUp() {
    super.setUp()
    mockUserDefaults = MockUserDefaults()
    pricingProvider = SubscriptionPricingProvider(storage: mockUserDefaults)
    productProvider = MockRevenuCatProductProvider(
      displayNameService: pricingProvider,
      allowsIOSDebugLog: true
    )
    purchaseProvider = generateMockProvider(didCancel: false, activeSubscriptions: ["co.pongo.bongo.annual"])
    userProvider = MockRevenueCatUserProvider(entitlementIdentifier: "ultimate", allowsIOSDebugLog: true)
  }

  // MARK: - Tests

  func testConfigurationPropertiesWithoutCustomisation() {
    coordinator.configure(
      apiKey: "newAPIKey",
      allowsRevenuCatDebug: false,
      allowsIOSDebugLog: false,
      storage: mockUserDefaults,
      productProvider: productProvider,
      purchaseManager: purchaseProvider,
      userProvider: userProvider
    )

    XCTAssertEqual(coordinator.apiKey, "newAPIKey", "API key should be updated after reconfiguration")
    XCTAssertFalse(
      coordinator.allowsRevenuCatDebug,
      "allowsRevenueDebug should be updated to true after reconfiguration"
    )
    XCTAssertFalse(
      coordinator.allowsIOSDebugLog,
      "allowsIOSLogDebug should be updated to true after reconfiguration"
    )
    XCTAssertNil(coordinator.customisationData, "Customisation data should be updated after reconfiguration")
  }

  func testConfigurationPropertiesWithCustomisation() {
    let customHeaderNames = SubscriptionTypeHeaderNames(
      annual: "Yearly",
      custom: "Custom Plan",
      lifetime: "Lifetime Access",
      monthly: "Monthly",
      sixMonth: "Semi-Annual",
      threeMonth: "Quarterly",
      twoMonth: "Bimonthly",
      unknown: "Unknown",
      weekly: "Weekly"
    )

    let customPriceSuffixes = SubscriptionTypeSuffixes(
      annual: " per annum",
      custom: " - Custom",
      lifetime: " one-time",
      monthly: " per month",
      sixMonth: " per 6 months",
      threeMonth: " per quarter",
      twoMonth: " every two months",
      unknown: " - ",
      weekly: " per week"
    )

    let customisationData = SubscriptionCustomisation(
      headerNames: customHeaderNames,
      priceSuffixes: customPriceSuffixes,
      termsAndConditions: TermsAndConditions()
    )

    coordinator.configure(
      apiKey: "newAPIKey",
      allowsRevenuCatDebug: true,
      allowsIOSDebugLog: true,
      customisationData: customisationData,
      storage: mockUserDefaults,
      productProvider: productProvider,
      purchaseManager: purchaseProvider,
      userProvider: userProvider
    )

    XCTAssertEqual(coordinator.apiKey, "newAPIKey", "API key should be updated after reconfiguration")
    XCTAssertTrue(
      coordinator.allowsRevenuCatDebug,
      "allowsRevenueDebug should be updated to true after reconfiguration"
    )
    XCTAssertTrue(
      coordinator.allowsIOSDebugLog,
      "allowsIOSLogDebug should be updated to true after reconfiguration"
    )
    XCTAssertNotNil(
      coordinator.customisationData,
      "Customisation data should not be nil after reconfiguration"
    )
    XCTAssertEqual(
      coordinator.customisationData?.headerNames,
      customHeaderNames,
      "Header names should match the configured customisation data"
    )
    XCTAssertEqual(
      coordinator.customisationData?.priceSuffixes,
      customPriceSuffixes,
      "Price suffixes should match the configured customisation data"
    )
  }
}
