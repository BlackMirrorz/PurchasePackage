//
//  ProductType.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/9/24.
//

import Foundation
import RevenueCat

// Convenience enum to map RevenueCat PackageTypes
public enum ProductType: String, CaseIterable {
  case annual
  case custom
  case lifetime
  case monthly
  case sixMonth
  case threeMonth
  case twoMonth
  case unknown
  case weekly
}

// MARK: - RevenueCat.PackageType + Extensions

extension RevenueCat.PackageType {
  public func toProductType() -> ProductType {
    switch self {
    case .annual:
      return .annual
    case .custom:
      return .custom
    case .lifetime:
      return .lifetime
    case .monthly:
      return .monthly
    case .sixMonth:
      return .sixMonth
    case .threeMonth:
      return .threeMonth
    case .twoMonth:
      return .twoMonth
    case .unknown:
      return .unknown
    case .weekly:
      return .weekly
    default:
      return .unknown
    }
  }
}
