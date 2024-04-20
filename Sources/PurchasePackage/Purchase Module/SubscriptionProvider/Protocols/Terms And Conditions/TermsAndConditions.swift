//
//  TermsAndConditions.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 3/27/24.
//

import Foundation

public struct TermsAndConditions: Equatable {
  var termsAndConditionsURL: URL
  var privacyPolicy: URL

  // MARK: - Initialization

  public init(
    termsAndConditionsURL: String = "https://www.twinkl.com/legal#terms-and-conditions",
    privacyPolicy: String = "https://www.twinkl.co.uk/legal#privacy-policy"
  ) {
    self.termsAndConditionsURL = URL(string: termsAndConditionsURL)!
    self.privacyPolicy = URL(string: privacyPolicy)!
  }
}

// MARK: - Helpers

extension TermsAndConditions {

  /// Returns the URL of the specified URLType
  /// - Parameter url: TermsAndConditionsURLType
  /// - Returns: URL
  public func urlFor(_ url: TermsAndConditionsURLType) -> URL {
    switch url {
    case .terms:
      return termsAndConditionsURL
    case .privacy:
      return privacyPolicy
    }
  }
}
