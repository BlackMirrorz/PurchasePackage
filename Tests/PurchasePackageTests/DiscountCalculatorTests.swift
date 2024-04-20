//
//  DiscountCalculatorTests.swift
//
//
//  Created by Josh Robbins on 4/15/24.
//

import Foundation
@testable import PurchasePackage
import RevenueCat
import StoreKit
import XCTest

final class DiscountCalculatorTests: XCTestCase {

  var discountCalculator: DiscountCalculator!
  var annualProduct: ProductInformation!
  var monthlyProduct: ProductInformation!
  var weeklyProduct: ProductInformation!
  var formatter: NumberFormatter!

  // MARK: - LifeCycle

  override func setUp() {
    super.setUp()
    annualProduct = generateAnnualProduct()
    monthlyProduct = generateMonthlyProduct()
    weeklyProduct = generateWeeklyProduct()
    discountCalculator = DiscountCalculator(products: [annualProduct, monthlyProduct, weeklyProduct])

    formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.maximumFractionDigits = 2
    formatter.multiplier = 1
  }

  override func tearDown() {
    annualProduct = nil
    monthlyProduct = nil
    weeklyProduct = nil
    discountCalculator = nil
    formatter = nil
    super.tearDown()
  }

  // MARK: - Tests

  func testDiscountLabelFormatting() {
    let discount = NSDecimalNumber(value: 0.23456)
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.maximumFractionDigits = 2
    let formattedDiscount = formatter.string(from: discount) ?? ""
    XCTAssertEqual(
      formattedDiscount,
      "23.46%",
      "The discount percentage is not formatted correctly."
    )
  }

  func testMonthlyEquivalentPrice() {
    let monthlyPriceForAnnual = discountCalculator.monthlyEquivalentPrice(product: annualProduct)
    XCTAssertEqual(
      monthlyPriceForAnnual,
      NSDecimalNumber(string: "0.49916666666666666666666666666666666666"),
      "Monthly equivalent for annual subscription is incorrect."
    )

    let semiAnnualProduct = generateProductInfo(price: NSDecimalNumber(string: "29.94"), type: .sixMonth)
    let monthlyPriceForSemiAnnual = discountCalculator.monthlyEquivalentPrice(product: semiAnnualProduct)
    XCTAssertEqual(
      monthlyPriceForSemiAnnual,
      NSDecimalNumber(string: "4.99"),
      "Monthly equivalent for six-month subscription is incorrect."
    )

    let quarterlyProduct = generateProductInfo(price: NSDecimalNumber(string: "14.97"), type: .threeMonth)
    let monthlyPriceForQuarterly = discountCalculator.monthlyEquivalentPrice(product: quarterlyProduct)
    XCTAssertEqual(
      monthlyPriceForQuarterly,
      NSDecimalNumber(string: "4.99"),
      "Monthly equivalent for three-month subscription is incorrect."
    )

    let biMonthlyProduct = generateProductInfo(price: NSDecimalNumber(string: "9.98"), type: .twoMonth)
    let monthlyPriceForBiMonthly = discountCalculator.monthlyEquivalentPrice(product: biMonthlyProduct)
    XCTAssertEqual(
      monthlyPriceForBiMonthly,
      NSDecimalNumber(string: "4.99"),
      "Monthly equivalent for two-month subscription is incorrect."
    )

    let monthlyPriceForMonthly = discountCalculator.monthlyEquivalentPrice(product: monthlyProduct)
    XCTAssertEqual(
      monthlyPriceForMonthly,
      NSDecimalNumber(string: "2.99"),
      "Monthly equivalent for monthly subscription is incorrect."
    )

    let weeklyPriceForWeekly = discountCalculator.monthlyEquivalentPrice(product: weeklyProduct)
    XCTAssertEqual(
      weeklyPriceForWeekly,
      NSDecimalNumber(string: "7.96"),
      "Monthly equivalent for weekly subscription is incorrect."
    )
  }

  func testCalculateDiscount() {
    let discountFromMonthlyToAnnual = discountCalculator.calculateDiscount(between: annualProduct, and: monthlyProduct)
    let expectedDiscountFromMonthlyToAnnual = (
      NSDecimalNumber(value: 2.99)
        .subtracting(NSDecimalNumber(value: 5.99 / 12)))
      .dividing(by: NSDecimalNumber(value: 2.99))
      .multiplying(by: 100)

    var difference = discountFromMonthlyToAnnual.subtracting(expectedDiscountFromMonthlyToAnnual)
    if difference.compare(NSDecimalNumber.zero) == .orderedAscending {
      difference = difference.multiplying(by: NSDecimalNumber(value: -1))
    }

    let tolerance = NSDecimalNumber(value: 0.0001)

    XCTAssertTrue(
      difference.compare(tolerance) != .orderedDescending,
      "The calculated discount from monthly to annual is incorrect."
    )

    let discountFromWeeklyToAnnual = discountCalculator.calculateDiscount(between: annualProduct, and: weeklyProduct)
    let expectedDiscountFromWeeklyToAnnual = (
      NSDecimalNumber(value: 1.99 * 4)
        .subtracting(NSDecimalNumber(value: 5.99 / 12)))
      .dividing(by: NSDecimalNumber(value: 1.99 * 4))
      .multiplying(by: 100)

    difference = discountFromWeeklyToAnnual.subtracting(expectedDiscountFromWeeklyToAnnual)

    if difference.compare(NSDecimalNumber.zero) == .orderedAscending {
      difference = difference.multiplying(by: NSDecimalNumber(value: -1))
    }
    XCTAssertTrue(
      difference.compare(tolerance) != .orderedDescending,
      "The calculated discount from weekly to annual is incorrect."
    )

    let discountFromWeeklyToMonthly = discountCalculator.calculateDiscount(between: monthlyProduct, and: weeklyProduct)
    let expectedDiscountFromWeeklyToMonthly = (
      NSDecimalNumber(value: 1.99 * 4)
        .subtracting(NSDecimalNumber(value: 2.99)))
      .dividing(by: NSDecimalNumber(value: 1.99 * 4))
      .multiplying(by: 100)

    difference = discountFromWeeklyToMonthly.subtracting(expectedDiscountFromWeeklyToMonthly)
    if difference.compare(NSDecimalNumber.zero) == .orderedAscending {
      difference = difference.multiplying(by: NSDecimalNumber(value: -1))
    }
    XCTAssertTrue(
      difference.compare(tolerance) != .orderedDescending,
      "The calculated savings from weekly to monthly is incorrect."
    )
  }

  func testDiscountLabel() {

    let discountLabelFromMonthlyToAnnual = discountCalculator.discountLabel(between: annualProduct, and: monthlyProduct)
    let discountLabelFromWeeklyToAnnual = discountCalculator.discountLabel(between: annualProduct, and: weeklyProduct)

    let discountCalculationMonthlyToAnnual = (
      NSDecimalNumber(value: 2.99)
        .subtracting(NSDecimalNumber(value: 5.99 / 12))
        .dividing(by: NSDecimalNumber(value: 2.99))
        .multiplying(by: 100)
    )

    let expectedDiscountFormattedMonthlyToAnnual = formatter.string(from: discountCalculationMonthlyToAnnual)!

    XCTAssertEqual(
      discountLabelFromMonthlyToAnnual,
      "Save \(expectedDiscountFormattedMonthlyToAnnual)",
      "The discount label from monthly to annual is incorrect."
    )

    let discountCalculationWeeklyToAnnual = (
      NSDecimalNumber(value: 1.99 * 4)
        .subtracting(NSDecimalNumber(value: 5.99 / 12))
        .dividing(by: NSDecimalNumber(value: 1.99 * 4))
        .multiplying(by: 100)
    )

    let expectedDiscountFormattedWeeklyToAnnual = formatter.string(from: discountCalculationWeeklyToAnnual)!

    XCTAssertEqual(
      discountLabelFromWeeklyToAnnual,
      "Save \(expectedDiscountFormattedWeeklyToAnnual)",
      "The discount label from weekly to annual is incorrect."
    )
  }

  func testNoDiscountScenario() {
    let noDiscountProduct = generateProductInfo(price: 2.99, type: .monthly)
    let noDiscountLabel = discountCalculator.discountLabel(between: noDiscountProduct, and: noDiscountProduct)
    XCTAssertNil(noDiscountLabel, "There should be no discount label when there is no savings.")
  }

  func testNegativeDiscountHandling() {
    let expensiveAnnualProduct = generateProductInfo(price: 50.00, type: .annual)
    let cheaperMonthlyProduct = generateProductInfo(price: 1.00, type: .monthly)
    let negativeDiscountLabel = discountCalculator.discountLabel(between: expensiveAnnualProduct, and: cheaperMonthlyProduct)
    XCTAssertNil(negativeDiscountLabel, "Negative discount should not produce a save label.")
  }

  // MARK: - Helpers

  func generateAnnualProduct() -> ProductInformation {
    generateProductInfo(price: 5.99, type: .annual)
  }

  func generateMonthlyProduct() -> ProductInformation {
    generateProductInfo(price: 2.99, type: .monthly)
  }

  func generateWeeklyProduct() -> ProductInformation {
    generateProductInfo(price: 1.99, type: .weekly)
  }

  func generateProductInfo(price: NSDecimalNumber, type: PackageType) -> ProductInformation {

    let mockProduct = StoreProduct(
      sk1Product: SKProduct(
        title: "mockSub",
        identifier: "product_456",
        price: price,
        priceLocale: Locale(identifier: "en_US")
      )
    )

    let mockPackage = RevenueCat.Package(
      identifier: "co.pongo.bongo.annual",
      packageType: type,
      storeProduct: mockProduct,
      offeringIdentifier: "fooBar"
    )

    return ProductInformation(package: mockPackage, subscriptionDisplayName: "", pricingText: "")
  }
}
