//
//  MockUserDefaults.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/8/24.
//

import Foundation
@testable import PurchasePackage

class MockUserDefaults: UserDefaultsProvidable {
  var store = [String: Any?]()

  func set(_ value: Any?, forKey defaultName: String) {
    store[defaultName] = value
  }

  func string(forKey defaultName: String) -> String? {
    store[defaultName] as? String
  }
}
