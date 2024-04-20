//
//  AppManagerAppleSubscriptionTests.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 3/26/24.
//

@testable import PurchasePackage
import RevenueCat
import StoreKit
import XCTest

final class AppManagerAppleSubscriptionTests: XCTestCase {

  var appManager: AppManager!
  private var mockOffering: Offering!
  private var entitlementIdentifier: String = "ultimate"
  private var didCancelPurchase = false
  private var activeSubscriptions: [String] = []
  private var userProvider: MockRevenueCatUserProvider!

  // MARK: - LifeCycle

  override func setUp() {
    super.setUp()
    appManager = AppManager.shared
    setupMockOffering()
    configureAppManagerForTest()
  }

  // MARK: - Helpers

  private func setupMockOffering() {
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

    mockOffering = Offering(
      identifier: "mockOffering",
      serverDescription: "mockServer",
      availablePackages: [mockPackage]
    )
  }

  private func configureAppManagerForTest() {
    let pricingProvider = SubscriptionPricingProvider()
    let productProvider = MockRevenuCatProductProvider(
      displayNameService: pricingProvider,
      allowsIOSDebugLog: true,
      mockOffering: mockOffering
    )

    let purchaseProvider = generateMockProvider(
      didCancel: didCancelPurchase,
      activeSubscriptions: ["co.pongo.bongo.annual"]
    )

    userProvider = MockRevenueCatUserProvider(
      entitlementIdentifier: entitlementIdentifier,
      allowsIOSDebugLog: true
    )

    appManager.configure(
      apiKey: "",
      productProvider: productProvider,
      purchaseManager: purchaseProvider,
      userProvider: userProvider
    )
  }

  // MARK: - Tests

  func testProductsAreReceivedCorrectly() async {
    do {
      let result = try await appManager.subscriptionManager.productProvider?.getOfferingAndAssociatedProducts()
      XCTAssertEqual(
        result?.products.count, 1, "There should be one product"
      )
      XCTAssertEqual(result?.products.first?.product.productIdentifier, "product_456", "Product identifiers should match")
    } catch {
      XCTFail("Fetching products failed with error: \(error)")
    }
  }

  func testUserHasUltimateAccess() async {
    entitlementIdentifier = "ultimate"
    activeSubscriptions = ["co.pongo.bongo.annual"]
    configureAppManagerForTest()
    userProvider.mockCustomerInfo = MockCustomerInfo(activeSubscriptions: ["ultimate"])

    do {
      let result = try await appManager.subscriptionManager.productProvider?.getOfferingAndAssociatedProducts()
      guard
        let product = result?.products.first
      else {
        XCTFail("Expected to find a product")
        return
      }
      _ = try await appManager.subscriptionManager.purchaseManager?.purchasePackage(productInformation: product)
      let isSubscriber = appManager.subscriptionManager.userProvider?.isAppleSubscriber() ?? false

      let isAppleSubscriber = appManager.isAppleSubscriber
      let isUltimateUser = appManager.isUltimateUser
      XCTAssertTrue(isSubscriber, "User should be recognized as an Apple Subscriber")
      XCTAssertTrue(isAppleSubscriber, "User should be an Apple Subscriber should be true")
      XCTAssertTrue(isUltimateUser, "User should be an Ultimate User")
    } catch {
      XCTFail("Test failed with error: \(error)")
    }
  }

  func testUserIsGuest() async {
    entitlementIdentifier = ""
    activeSubscriptions = []
    configureAppManagerForTest()

    do {
      let result = try await appManager.subscriptionManager.productProvider?.getOfferingAndAssociatedProducts()
      guard
        let product = result?.products.first
      else {
        XCTFail("Expected to find a product")
        return
      }
      _ = try await appManager.subscriptionManager.purchaseManager?.purchasePackage(productInformation: product)
      let isSubscriber = appManager.subscriptionManager.userProvider?.isAppleSubscriber() ?? false

      XCTAssertFalse(isSubscriber, "User should not be recognized as an Apple Subscriber")
      XCTAssertFalse(appManager.isAppleSubscriber, "isAppleSubscriber should be false")
      XCTAssertFalse(appManager.isUltimateUser, "isUltimateUser should be false")
    } catch {
      XCTFail("Test failed with error: \(error)")
    }
  }
}
