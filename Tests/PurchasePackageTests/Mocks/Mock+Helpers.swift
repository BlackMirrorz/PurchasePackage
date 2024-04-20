//
//  Mock+Helpers.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/11/24.
//

import Foundation
@testable import PurchasePackage
import RevenueCat
import StoreKit

func generateMockProvider(didCancel: Bool, activeSubscriptions: Set<String>) -> MockRevenuCatPurchaseProvider {
  let pricingProvider = MockSubscriptionPricingProvider(storage: MockUserDefaults())

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

  let information = ProductInformation(
    package: mockPackage,
    subscriptionDisplayName: pricingProvider.headerName(forType: .annual),
    pricingText: pricingProvider.pricingText(forType: .annual)
  )

  let mockCustomerInfo = MockCustomerInfo(activeSubscriptions: activeSubscriptions)

  let mockProvider = MockRevenuCatPurchaseProvider(allowsIOSDebugLog: false)

  mockProvider.configure(
    mockPurchaseResultData: MockPurchaseResultData(customerInfo: mockCustomerInfo, userCancelled: didCancel),
    productInformation: information
  )
  return mockProvider
}
