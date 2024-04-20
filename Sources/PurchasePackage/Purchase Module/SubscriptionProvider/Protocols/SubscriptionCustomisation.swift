//
//  SubscriptionCustomisation.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/8/24.
//

import Foundation
import RevenueCat
import StoreKit

// MARK: - SubscriptionCustomisation

/// Structure encapsulating customization options for subscription-related display elements.
public struct SubscriptionCustomisation: Equatable {
  /// Custom display names for public var ious subscription types.
  /// These names are used in UI elements where subscription options are presented.
  public var headerNames: SubscriptionTypeHeaderNames

  /// Custom suffixes for subscription pricing.
  /// These suffixes are appended to pricing information, providing additional context or localization.
  public var priceSuffixes: SubscriptionTypeSuffixes

  /// The URL's for Terms & Condition and Privacy Policies
  public var termsAndConditions: TermsAndConditions
}

// MARK: - SubscriptionTypeHeaderNames

/// Structure defining custom display names for different subscription types.
public struct SubscriptionTypeHeaderNames: Equatable {
  public var annual: String = "Annual Subscription"
  public var custom: String = "Custom Subscription"
  public var lifetime: String = "Lifetime Subscription"
  public var monthly: String = "Monthly Subscription"
  public var sixMonth: String = "6 Month Subscription"
  public var threeMonth: String = "3 Month Subscription"
  public var twoMonth: String = "2 Month Subscription"
  public var unknown: String = "Unknown Subscription"
  public var weekly: String = "Weekly Subscription"
}

// MARK: - SubscriptionTypeSuffixes

/// Structure defining custom suffixes for displaying subscription pricing information.
public struct SubscriptionTypeSuffixes: Equatable {
  public var annual: String = " per year"
  public var custom: String = "Custom"
  public var lifetime: String = " for lifetime access"
  public var monthly: String = " per month"
  public var sixMonth: String = " / 6 Months"
  public var threeMonth: String = " /3 Months"
  public var twoMonth: String = " /2 Months"
  public var unknown: String = "Unknown"
  public var weekly: String = "per week"
}
