//
//  UserDefaultsProvidable.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/8/24.
//

import Foundation

// MARK: - UserDefaultsProvidable

/// Protocol defining the interface for UserDefaults storage, allowing for custom implementation or mocking.
public protocol UserDefaultsProvidable {
  /// Sets a value for the specified default key.
  /// - Parameters:
  ///   - value: The value to store in UserDefaults.
  ///   - defaultName: The key under which to store the value.
  func set(_ value: Any?, forKey defaultName: String)

  /// Retrieves a string for the specified default key.
  /// - Parameter defaultName: The key for which to retrieve the stored string.
  /// - Returns: The string value associated with the specified key, or nil if the key does not exist.
  func string(forKey defaultName: String) -> String?
}

// MARK: - UserDefaults + UserDefaultsProvidable

/// Extension to conform UserDefaults to the UserDefaultsProvidable protocol, enabling its use with custom storage  logic.
extension UserDefaults: UserDefaultsProvidable {}
