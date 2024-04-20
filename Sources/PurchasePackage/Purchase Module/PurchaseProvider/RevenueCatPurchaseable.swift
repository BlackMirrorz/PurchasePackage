//
//  RevenueCatPurchaseable.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/10/24.
//

import Foundation

/// RevenueCatPurchasable is responsible for the purchasing and restoration of Subscriptions and IAP
public protocol RevenueCatPurchaseable: PackageDebuggable {
  ///  Initiates the purchase process for a specified product.
  /// - Parameter productInformation: An instance containing all necessary information about the product to be
  /// purchased, such as its identifier and price.
  /// - Throws: An error if the purchase process cannot be initiated or completed. This allows for error handling to
  /// manage issues like network errors, user cancellation, or other purchase failures.
  /// This function is asynchronous, indicated by `async`, allowing it to perform network requests or other long-running
  /// tasks in a non-blocking way, awaiting their completion.
  func purchasePackage(productInformation: ProductInformation) async throws

  /// Initiates the process to restore previously made purchases.
  /// - Throws: An error if the restore process cannot be initiated or completed. This could be due to network issues,
  /// no purchases to restore, or other errors.
  func restorePurchases() async throws

  /// Initiaizer used to determine whether IOSLogging is enabled
  /// - Parameter allowsIOSDebugLog: Whether IOSLogging is enabled
  init(allowsIOSDebugLog: Bool)
}
