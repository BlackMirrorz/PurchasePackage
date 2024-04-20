//
//  MockRevenueCatProvider.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/9/24.
//

import Foundation
@testable import PurchasePackage
import RevenueCat

final class MockRevenuCatProductProvider: RevenueCatProductsProvidable {

  var currentOffering: Offering?

  var availableProducts: [ProductInformation] = []

  var allowsIOSDebugLog: Bool

  var displayNameService: SubscriptionPricingProvidable

  var discountCalculator: PurchasePackage.DiscountCalculator

  // MARK: - Initialization

  init(displayNameService: SubscriptionPricingProvidable, allowsIOSDebugLog: Bool = true) {
    self.displayNameService = displayNameService
    self.allowsIOSDebugLog = allowsIOSDebugLog
    self.discountCalculator = DiscountCalculator(products: availableProducts)
  }

  required init(
    displayNameService: SubscriptionPricingProvidable,
    allowsIOSDebugLog: Bool,
    mockOffering: RevenueCat.Offering?
  ) {
    self.displayNameService = displayNameService
    self.allowsIOSDebugLog = allowsIOSDebugLog
    self.currentOffering = mockOffering
    self.discountCalculator = DiscountCalculator(products: availableProducts)
  }

  // MARK: - Callbacks

  func getOfferingAndAssociatedProducts() async throws
    -> (offering: RevenueCat.Offering, products: [ProductInformation]) {

    if let currentOffering = currentOffering {
      let availableProducts = await getAvailableProducts(for: currentOffering)
      let availbleProductsWithTrialsAdjusted = await checkProductIsEligibleForTrial(for: availableProducts)
      discountCalculator = DiscountCalculator(products: availableProducts)
      return (currentOffering, availbleProductsWithTrialsAdjusted)
    } else {
      throw RevenueCatError.offeringsNotFound
    }
  }

  func getCurrentOffering() async throws -> RevenueCat.Offering {
    do {

      guard
        let currentOffer = currentOffering else {
        throw RevenueCatError.offeringsNotFound
      }
      return currentOffer
    } catch {
      throw error
    }
  }

  func checkProductIsEligibleForTrial(for availableProducts: [ProductInformation]) async -> [ProductInformation] {
    availableProducts
  }

  func getAvailableProducts(for offering: RevenueCat.Offering?) async -> [ProductInformation] {
    offering?.availablePackages.compactMap { package in
      let displayName = self.displayNameService.headerName(forType: package.packageType.toProductType())
      let displayPrice = self.displayNameService.pricingText(forType: package.packageType.toProductType())
      return ProductInformation(
        package: package,
        subscriptionDisplayName: displayName,
        pricingText: displayPrice
      )
    } ?? []
  }
}
