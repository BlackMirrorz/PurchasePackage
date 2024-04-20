//
//  MockRevenueCatPurchaseManager.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/10/24.
//

import Foundation
@testable import PurchasePackage
import RevenueCat

final class MockRevenuCatPurchaseProvider: RevenueCatPurchaseable {
  var allowsIOSDebugLog: Bool
  var mockPurchaseResultData: MockPurchaseResultData!
  var mockProductInformation: ProductInformation!

  // MARK: - Initialization

  init(allowsIOSDebugLog: Bool = true) {
    self.allowsIOSDebugLog = allowsIOSDebugLog
  }

  func configure(mockPurchaseResultData: MockPurchaseResultData, productInformation: ProductInformation) {
    self.mockPurchaseResultData = mockPurchaseResultData
    mockProductInformation = productInformation
  }

  // MARK: - Callbacks

  func purchasePackage(productInformation _: ProductInformation) async throws {
    guard
      let mockPurchaseResultData = mockPurchaseResultData else {
      assertionFailure("mockData connot be nil")
      return
    }

    let result = mockPurchaseResultData

    switch result.userCancelled {
    case true:
      throw RevenueCatError.userDidCancelPurchase
    case false:
      let purchaseData = result.customerInfo.activeSubscriptions

      guard
        !purchaseData.isEmpty
      else {
        throw RevenueCatError.noSubscriptionMade
      }
    }
  }

  func restorePurchases() async throws {
    guard
      let mockPurchaseResultData = mockPurchaseResultData else {
      assertionFailure("mockData connot be nil")
      return
    }

    let result = mockPurchaseResultData

    let purchaseData = result.customerInfo.activeSubscriptions

    guard !purchaseData.isEmpty else {
      throw RevenueCatError.unableToRestoreSubscription
    }
  }
}

// MARK: - MockPurchaseResultData

struct MockPurchaseResultData {
  var transaction: MockStoreTransaction?
  var customerInfo: MockCustomerInfo
  var userCancelled: Bool
}

// MARK: - MockStoreTransaction

struct MockStoreTransaction {
  var productIdentifier: String
  var purchaseDate: Date
  var transactionIdentifier: String
  var quantity: Int
}
