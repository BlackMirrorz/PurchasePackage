//
//  MockSubscriptionPricingProvider.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/8/24.
//

import Foundation
@testable import PurchasePackage

final class MockSubscriptionPricingProvider: SubscriptionPricingProvidable {
  private var storage: UserDefaultsProvidable

  // MARK: - Initialization

  init(storage: UserDefaultsProvidable) {
    self.storage = storage
  }

  // MARK: - Callbacks

  func pricingText(forType type: ProductType) -> String {
    let key = UserDefaultsKeys.priceSuffixKey(forType: type)
    return storage.string(forKey: key) ?? "Default Pricing"
  }

  func headerName(forType type: ProductType) -> String {
    let key = UserDefaultsKeys.displayTextKey(forType: type)
    return storage.string(forKey: key) ?? "Default Name"
  }
}
