//
//  RevenueCatError.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/10/24.
//

import Foundation

/// Custom errors specific to RevenueCat & purchasing operations
public enum RevenueCatError: Error, Equatable {
  case offeringsNotFound
  case unableToGetCurrentUserInformation
  case userDidCancelPurchase
  case noSubscriptionMade
  case subscriptionError(String)
  case restoreError(String)
  case unableToRestoreSubscription

  public var message: String {
    switch self {
    case .offeringsNotFound:
      return "No subscriptions or IAP available for this app."
    case .unableToGetCurrentUserInformation:
      return "Sorry we were unable to get information for the current user."
    case .userDidCancelPurchase:
      return "You have cancelled the current transaction.\nPlease try again."
    case .noSubscriptionMade:
      return "Sorry we were unable to process your transaction.\nPlease try again"
    case .subscriptionError:
      return "Sorry we were unable to restore your purchases.\nPlease try again"
    case .restoreError:
      return "Sorry we were unable to restore your purchases.\nPlease try again"
    case .unableToRestoreSubscription:
      return "Sorry we were unable to restore your purchases.\nPlease try again"
    }
  }
}
