//
//  ProductInformation.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/9/24.
//

import Foundation
import RevenueCat

/// Structure representing all of the data for a given subscription of IAP
public struct ProductInformation: ProductInfoConstructable, Identifiable, Hashable {

  public var id: String = UUID().uuidString

  public var type: ProductType

  public var identifier: String

  public var product: RevenueCat.StoreProduct

  public var package: RevenueCat.Package

  public var price: NSDecimalNumber

  public var localizedPrice: String?

  public var productIdentifier: String

  public var subscriptionDisplayName: String

  public var pricingDisplayText: String

  public var debugDescription: String

  public var isEligibleForTrial: Bool

  public var freeTrialMessageText: String?

  public var subscriptionMessage: String = ""

  public var appName: String

  // MARK: - Initialization

  public init(package: RevenueCat.Package, subscriptionDisplayName: String, pricingText: String) {
    self.type = package.packageType.toProductType()
    self.product = package.storeProduct
    self.package = package
    self.localizedPrice = package.storeProduct.localizedPriceString
    self.productIdentifier = package.storeProduct.productIdentifier
    self.identifier = package.identifier
    self.price = package.storeProduct.priceDecimalNumber
    self.subscriptionDisplayName = subscriptionDisplayName
    self.pricingDisplayText = package.storeProduct.localizedPriceString + pricingText
    self.isEligibleForTrial = false

    if let trialProduct = product.introductoryDiscount, trialProduct.paymentMode == .freeTrial {
      let unitValue = trialProduct.subscriptionPeriod.value
      let duration = trialProduct.subscriptionPeriod.unit

      func unitLabel(for unit: SubscriptionPeriod.Unit, with value: Int) -> String {
        switch unit {
        case .day:
          return value > 1 ? "Days" : "Day"
        case .week:
          return value > 1 ? "Weeks" : "Week"
        case .month:
          return value > 1 ? "Months" : "Month"
        case .year:
          return value > 1 ? "Years" : "Year"
        }
      }

      let unitText = unitLabel(for: duration, with: unitValue)
      self.freeTrialMessageText = "\(unitValue) \(unitText) Free Trial"
    }

    self.debugDescription = """
    type: \(type.rawValue),
    identifier: \(identifier),
    product: \(product),
    price: \(price),
    localizedPrice: \(localizedPrice ?? "nil"),
    productIdentifier: \(productIdentifier)
    freeTrialText: \(freeTrialMessageText ?? "")
    """
    self.appName = Bundle.appName ?? ""
    generatesubscriptionMessage()
  }
}

// MARK: - Subscription Message

extension ProductInformation {

  // swiftlint:disable line_length
  mutating func generatesubscriptionMessage() {
    var subscriptionEnd = ""
    var message = ""

    switch package.packageType {
    case .unknown, .custom, .lifetime:
      return
    case .annual:
      subscriptionEnd = "year"
    case .sixMonth:
      subscriptionEnd = "six month period"
    case .threeMonth:
      subscriptionEnd = "three month period"
    case .twoMonth:
      subscriptionEnd = "two month period"
    case .monthly:
      subscriptionEnd = "month"
    case .weekly:
      subscriptionEnd = "week"
    }

    if isEligibleForTrial, let freeTrialMessageText = freeTrialMessageText {
      message = "Your \(freeTrialMessageText) can be cancelled at anytime before the trial duration is complete. After this, "
    }

    let prefix = isEligibleForTrial ? "your" : "Your"

    message += """
    \(prefix) \(appName) \(subscriptionDisplayName.lowercased()) will automatically renew at the end of every \(subscriptionEnd), and your credit card will be charged through your Apple ID account. You can disable auto-renewal at any time from your App Store account settings, but refunds will not be provided for any unused portion of the term. Your subscription automatically renews unless you disable it in your App Store account settings at least 24 hours before the end of the billing period.
    """

    subscriptionMessage = message
  }
  // swiftlint:enable line_length
}

// MARK: - Mutation Helpers

extension ProductInformation {

  public mutating func setIsElibleForTrial() {
    isEligibleForTrial = true
    generatesubscriptionMessage()
  }

  public mutating func setAppName(_ appName: String) {
    self.appName = appName
    generatesubscriptionMessage()
  }

  public mutating func setFreeTrialMessgeText(_ text: String) {
    freeTrialMessageText = text
  }
}
