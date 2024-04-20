//
//  DiscountCalculator.swift
//
//
//  Created by Josh Robbins on 4/15/24.
//

import Foundation

/**
 This struct is responsible for calculating price savings between various product offerings,
 which can be used to determine financial benefits for different subscription plans.
 */
public struct DiscountCalculator {

  /// A list of products for which discounts are calculated.
  public var products: [ProductInformation]

  // MARK: - Initialization

  public init(products: [ProductInformation]) {
    self.products = products
  }

  // MARK: - Functions

  /**
   Calculates the monthly equivalent price of a product based on its subscription period.

   - Parameter product: A `ProductInformation` object representing a product's details.
   - Returns: The price per month as an `NSDecimalNumber`. Returns `notANumber` for products without a straightforward monthly equivalent.
   */
  public func monthlyEquivalentPrice(product: ProductInformation) -> NSDecimalNumber {
    switch product.type {
    case .annual:
      return product.price.dividing(by: NSDecimalNumber(value: 12))
    case .sixMonth:
      return product.price.dividing(by: NSDecimalNumber(value: 6))
    case .threeMonth:
      return product.price.dividing(by: NSDecimalNumber(value: 3))
    case .twoMonth:
      return product.price.dividing(by: NSDecimalNumber(value: 2))
    case .monthly:
      return product.price
    case .weekly:
      return product.price.multiplying(by: NSDecimalNumber(value: 4))
    case .lifetime, .custom, .unknown:
      return NSDecimalNumber.notANumber
    }
  }

  /**
   Calculates the discount percentage between two products based on their monthly prices.

   - Parameters:
     - baseProduct: The baseline product for comparison.
     - comparisonProduct: The product to compare against the base product.
   - Returns: The discount as a percentage if applicable, otherwise returns zero.
   */
  public func calculateDiscount(between baseProduct: ProductInformation, and comparisonProduct: ProductInformation) -> NSDecimalNumber {
    let monthlyPriceBase = monthlyEquivalentPrice(product: baseProduct)
    let monthlyPriceComparison = monthlyEquivalentPrice(product: comparisonProduct)

    if monthlyPriceComparison == NSDecimalNumber.notANumber {
      return NSDecimalNumber.zero // No comparison possible if monthly price is not calculable
    }

    let discount = (
      monthlyPriceComparison
        .subtracting(monthlyPriceBase))
      .dividing(by: monthlyPriceComparison)
      .multiplying(by: NSDecimalNumber(value: 100)
      )
    return discount
  }

  /**
   Generates a discount label describing the savings between two products.

   - Parameters:
     - baseProduct: The baseline product for comparison.
     - comparisonProduct: The product to compare against the base.
   - Returns: A string representing the savings in percentage or `nil` if no savings.
   */
  public func discountLabel(
    between baseProduct: ProductInformation,
    and comparisonProduct: ProductInformation
  ) -> String? {
    let discount = calculateDiscount(between: baseProduct, and: comparisonProduct)

    if discount.compare(NSDecimalNumber.zero) == .orderedAscending {
      return nil
    }

    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.maximumFractionDigits = 2
    formatter.multiplier = 1

    if discount == 0 {
      return nil
    } else if let formattedDiscount = formatter.string(from: discount) {
      return "Save \(formattedDiscount)"
    } else {
      return "Save \(discount)%"
    }
  }
}
