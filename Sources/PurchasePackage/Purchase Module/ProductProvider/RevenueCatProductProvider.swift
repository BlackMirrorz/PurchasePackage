//
//  RevenueCatProductProvider.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/9/24.
//

import Foundation
import RevenueCat

/// Class which provides the default implementation of  RevenueCatProductsProvidable.
///  It is responsible for listing the current available products/subscriptions in the App
public final class RevenuCatProductProvider: RevenueCatProductsProvidable {

  public var discountCalculator: DiscountCalculator

  public var currentOffering: Offering?

  public var availableProducts: [ProductInformation] = []

  public var allowsIOSDebugLog: Bool

  public var displayNameService: SubscriptionPricingProvidable

  // MARK: - Initialization

  public init(displayNameService: SubscriptionPricingProvidable, allowsIOSDebugLog: Bool) {
    self.displayNameService = displayNameService
    self.allowsIOSDebugLog = allowsIOSDebugLog
    self.discountCalculator = DiscountCalculator(products: availableProducts)
  }

  // MARK: - Callbacks

  public func getOfferingAndAssociatedProducts() async throws
    -> (offering: RevenueCat.Offering, products: [ProductInformation]) {
    let currentOffering = try await getCurrentOffering()
    let availableProducts = await getAvailableProducts(for: currentOffering)
    let availbleProductsWithTrialsAdjusted = await checkProductIsEligibleForTrial(for: availableProducts)
    discountCalculator = DiscountCalculator(products: availbleProductsWithTrialsAdjusted)
    return (currentOffering, availbleProductsWithTrialsAdjusted)
  }

  public func getCurrentOffering() async throws -> RevenueCat.Offering {
    do {
      let offerings = try await Purchases.shared.offerings()
      guard
        let currentOffer = offerings.current else {
        throw RevenueCatError.offeringsNotFound
      }
      return currentOffer
    } catch {
      throw error
    }
  }

  public func checkProductIsEligibleForTrial(for availableProducts: [ProductInformation]) async -> [ProductInformation] {
    var modifiedProducts = availableProducts
    let packages = modifiedProducts.map(\.package)
    let eligibilityInfo = await Purchases.shared.checkTrialOrIntroDiscountEligibility(packages: packages)

    for (index, product) in modifiedProducts.enumerated() {
      if let eligibility = eligibilityInfo[product.package], eligibility.status == .eligible {
        modifiedProducts[index].isEligibleForTrial = true
      } else {
        modifiedProducts[index].isEligibleForTrial = false
      }
    }

    return modifiedProducts
  }

  public func getAvailableProducts(for offering: RevenueCat.Offering?) async -> [ProductInformation] {
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
