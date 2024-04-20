//
//  RevenueCatProductsProvidable.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/9/24.
//

import Foundation
import RevenueCat

/// RevenueCatProductsProvidable is the protocol for listing the current available products/subscriptions in the App
public protocol RevenueCatProductsProvidable: PackageDebuggable {
  /// Service for providing subscription pricing and display text, utilizing UserDefaults for local storage.
  var displayNameService: SubscriptionPricingProvidable { get }

  /// The current offering retrieved from the App Store via RevenueCat.
  var currentOffering: RevenueCat.Offering? { get }

  /// Collection of available products associated with the current offering.
  var availableProducts: [ProductInformation] { get }

  /// Caluclator for working out potential savings beetween packages
  var discountCalculator: DiscountCalculator { get }

  /// Retrieves the current offering from RevenueCat and the associated products.
  /// This asynchronous method may throw errors, handling situations where fetching offerings or products fails.
  /// - Returns: A tuple containing the current offering and an array of product information.
  func getOfferingAndAssociatedProducts() async throws -> (offering: RevenueCat.Offering, products: [ProductInformation])

  /// Fetches the current offering from RevenueCat asynchronously.
  /// This method may throw errors if there are issues retrieving the offering.
  /// - Returns: The current offering from RevenueCat.
  func getCurrentOffering() async throws -> RevenueCat.Offering

  /// Checks which available products are eligible for a trial period.
  /// This asynchronous method filters the products based on trial eligibility, useful for promotional displays.
  /// - Parameter availableProducts: An array of ProductInformation representing the current available products.
  /// - Returns: A filtered array of ProductInformation where each product is eligible for a trial.
  func checkProductIsEligibleForTrial(for availableProducts: [ProductInformation]) async -> [ProductInformation]

  /// Retrieves available products for a given offering.
  /// This asynchronous method fetches products associated with a specific offering, facilitating dynamic product
  /// displays based on offerings.
  /// - Parameter offering: The specific offering to retrieve products for. Can be nil, in which case it might fetch
  /// default or all products.
  /// - Returns: An array of ProductInformation for the products available under the specified offering.
  func getAvailableProducts(for offering: RevenueCat.Offering?) async -> [ProductInformation]

  /// Initializes a conforming instance with a display name service and a debug log option.
  /// - Parameters:
  ///   - displayNameService: The service used for managing subscription pricing and display names.
  ///   - allowsIOSDebugLog: A Boolean indicating whether iOS debug logging should be enabled, useful for development
  /// and troubleshooting.
  init(displayNameService: SubscriptionPricingProvidable, allowsIOSDebugLog: Bool)
}
