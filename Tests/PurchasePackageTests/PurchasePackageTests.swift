//
//  PurchasePackageTests.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/4/24.
//

@testable import PurchasePackage
import RevenueCat
import StoreKit
import XCTest

final class PurchasePackageTests: XCTestCase {
  func testRevenueCatPackageTypesMatchProductType() {
    let mappings: [RevenueCat.PackageType: ProductType] = [
      .annual: .annual,
      .sixMonth: .sixMonth,
      .threeMonth: .threeMonth,
      .twoMonth: .twoMonth,
      .monthly: .monthly,
      .weekly: .weekly,
      .custom: .custom,
      .lifetime: .lifetime,
      .unknown: .unknown
    ]

    for (packageType, expectedProductType) in mappings {
      let convertedProductType = packageType.toProductType()
      XCTAssertEqual(
        convertedProductType,
        expectedProductType,
        "Failed to map \(packageType) to \(expectedProductType)"
      )
    }
  }

  // swiftlint:disable line_length
  func testProductInformationMapsCorrectly() {

    let storage = MockUserDefaults()
    let key = UserDefaultsKeys.displayTextKey(forType: .annual)
    storage.set("Annual Subscription", forKey: key)

    let pricingProvider = MockSubscriptionPricingProvider(storage: storage)

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

    var information = ProductInformation(
      package: mockPackage,
      subscriptionDisplayName: pricingProvider.headerName(forType: .annual),
      pricingText: pricingProvider.pricingText(forType: .annual)
    )

    print(pricingProvider.headerName(forType: .annual))
    information.setIsElibleForTrial()
    information.setFreeTrialMessgeText("7 day Free Trial")
    information.setAppName("Twinkl App")
    XCTAssertEqual(information.productIdentifier, "product_456", "Offering identifier should match")
    XCTAssertEqual(information.identifier, "co.pongo.bongo.annual", "Information identifier should map correctly")
    XCTAssertEqual(information.type, .annual, "ProductType should be annual")
    XCTAssertEqual(information.price, 9.99, "{roduct price should be 9.99")
    XCTAssertEqual(information.localizedPrice, "$9.99", "Localized price should be $9.99")

    let message =
      """
      Your 7 day Free Trial can be cancelled at anytime before the trial duration is complete. After this, your Twinkl App annual subscription will automatically renew at the end of every year, and your credit card will be charged through your Apple ID account. You can disable auto-renewal at any time from your App Store account settings, but refunds will not be provided for any unused portion of the term. Your subscription automatically renews unless you disable it in your App Store account settings at least 24 hours before the end of the billing period.
      """

    XCTAssertEqual(information.subscriptionMessage, message)
  }
  // swiftlint:enable line_length
}
