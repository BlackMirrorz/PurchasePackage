//
//  UserDefaultsKeys.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/8/24.
//

import Foundation

/// Utility struct for managing UserDefaults keys specific to subscription pricing and display texts.
enum UserDefaultsKeys {
  /// Generates a key for accessing display text for a given subscription type.
  /// - Parameter type: The type of product for which to generate the key.
  /// - Returns: A string key used to store or retrieve the display text from UserDefaults.
  static func displayTextKey(forType type: ProductType) -> String {
    "displayText\(type.rawValue)"
  }

  /// Generates a key for accessing the price suffix for a given subscription type.
  /// - Parameter type: The type of product for which to generate the key.
  /// - Returns: A string key used to store or retrieve the price suffix from UserDefaults.
  static func priceSuffixKey(forType type: ProductType) -> String {
    "priceSuffix\(type.rawValue)"
  }
}
