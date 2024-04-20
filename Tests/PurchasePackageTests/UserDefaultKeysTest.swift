//
//  UserDefaultKeysTest.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/8/24.
//

@testable import PurchasePackage
import RevenueCat
import XCTest

final class UserDefaultKeysTest: XCTestCase {
  func testDisplayTextKeyForType() {
    for type in ProductType.allCases {
      let expectedKey = "displayText\(type.rawValue)"
      XCTAssertEqual(
        UserDefaultsKeys.displayTextKey(forType: type),
        expectedKey,
        "displayTextKey for \(type) should be \(expectedKey)"
      )
    }
  }

  func testPriceSuffixKeyForType() {
    for type in ProductType.allCases {
      let expectedKey = "priceSuffix\(type.rawValue)"
      XCTAssertEqual(
        UserDefaultsKeys.priceSuffixKey(forType: type),
        expectedKey,
        "priceSuffixKey for \(type) should be \(expectedKey)"
      )
    }
  }
}
