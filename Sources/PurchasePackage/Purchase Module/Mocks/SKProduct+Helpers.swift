//
//  SKProduct+Helpers.swift
//
//
//  Created by Josh Robbins on 4/15/24.
//

import StoreKit

// MARK: - SKProduct Helpers

extension SKProduct {
  public convenience init(
    title: String,
    identifier: String,
    price: NSDecimalNumber,
    priceLocale: Locale
  ) {
    self.init()
    setValue(title, forKey: "localizedTitle")
    setValue(identifier, forKey: "productIdentifier")
    setValue(price, forKey: "price")
    setValue(priceLocale, forKey: "priceLocale")
  }
}

// MARK: - SKProductDiscount Helpers

extension SKProductDiscount {
  public convenience init(
    price: String,
    priceLocale: Locale,
    subscriptionPeriod: SKProductSubscriptionPeriod,
    numberOfPeriods: Int
  ) {
    self.init()
    setValue(NSDecimalNumber(string: price), forKey: "price")
    setValue(priceLocale, forKey: "priceLocale")
    setValue(subscriptionPeriod, forKey: "subscriptionPeriod")
    setValue(numberOfPeriods, forKey: "numberOfPeriods")
  }
}

// MARK: - SKProductSubscriptionPeriod Helpers

extension SKProductSubscriptionPeriod {
  public convenience init(
    numberOfUnits: Int,
    unit: SKProduct.PeriodUnit
  ) {
    self.init()
    setValue(numberOfUnits, forKey: "numberOfUnits")
    setValue(unit.rawValue, forKey: "unit")
  }
}
