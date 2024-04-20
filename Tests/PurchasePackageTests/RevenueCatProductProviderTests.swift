//
//  RevenueCatProductProviderTests.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/9/24.
//

@testable import PurchasePackage
import RevenueCat
import StoreKit
import XCTest

final class RevenueCatProductProviderTests: XCTestCase {
  private var mockUserDefaults: MockUserDefaults!
  private var pricingProvider: SubscriptionPricingProvider!

  // MARK: - LifeCycle

  override func setUp() {
    super.setUp()
    mockUserDefaults = MockUserDefaults()
    pricingProvider = SubscriptionPricingProvider(storage: mockUserDefaults)
  }

  // MARK: - Tests

  func testValidffering() {
    let mockProduct = StoreProduct(
      sk1Product: SKProduct(
        title: "mockSub",
        identifier: "product_456",
        price: 9.99,
        priceLocale: Locale(identifier: "en_US")
      )
    )

    let mockPackage = RevenueCat.Package(
      identifier: "co.pongo.bongo.annual",
      packageType: .annual,
      storeProduct: mockProduct,
      offeringIdentifier: "fooBar"
    )

    let mockOffering = Offering(
      identifier: "mockOffering",
      serverDescription: "mockServer",
      availablePackages: [mockPackage]
    )

    let provider = MockRevenuCatProductProvider(
      displayNameService: pricingProvider,
      allowsIOSDebugLog: true,
      mockOffering: mockOffering
    )

    XCTAssertEqual(provider.currentOffering?.identifier, "mockOffering")
    XCTAssertEqual(provider.currentOffering?.availablePackages.count, 1)

    if let validPackage = provider.currentOffering?.availablePackages.first {
      let information = ProductInformation(
        package: validPackage,
        subscriptionDisplayName: "test",
        pricingText: "9.99 per month"
      )
      XCTAssertEqual(information.productIdentifier, "product_456", "offering identifier should match")
      XCTAssertEqual(
        information.identifier,
        "co.pongo.bongo.annual",
        "information identifier should map correctly"
      )
      XCTAssertEqual(information.type, .annual, "productType should be annual")
      XCTAssertEqual(information.price, 9.99, "product price should be 9.99")
      XCTAssertEqual(information.localizedPrice, "$9.99", "localized price should be $9.99")
    } else {
      XCTFail("Package should be valid")
    }
  }

  func testInvalidOffering() {
    let provider = MockRevenuCatProductProvider(displayNameService: pricingProvider, allowsIOSDebugLog: true)
    XCTAssertNil(provider.currentOffering)
    XCTAssertEqual(provider.availableProducts.count, 0)
  }
}
