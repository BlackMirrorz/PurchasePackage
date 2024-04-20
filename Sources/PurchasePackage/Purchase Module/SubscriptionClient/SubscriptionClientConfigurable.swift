//
//  SubscriptionClientConfigurable.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/11/24.
//

import Foundation
import NetworkingLayer

/// The SubscriptionClientConfigurable  protocol defines a comprehensive set of requirements for managing in App Purchases & Subscriptions within the App.
public protocol SubscriptionClientConfigurable {

  /// `RevenueCatPurchasable` responsible for the purchasing and restoration of Subscriptions and IAP
  var purchaseManager: RevenueCatPurchaseable { get }

  /// Responsible for updating the UI when fetching subsctiptions or IAP's.
  var productLoadingState: LoadingState { get }

  /// `RevenueCatProductsProvidable` responsible for listing the current available products/subscriptions in the App.
  var productProvider: RevenueCatProductsProvidable { get }

  /// The available products available for the user to purchase.
  var availableProducts: [ProductInformation] { get }

  /// Responsible for retrieving information about the Use.
  /// This protocol extends PackageDebuggable for debugging purposes and conforms to RevenueCat.PurchasesDelegate
  /// to handle updates or changes in purchase information directly from RevenueCat.
  var userProvider: RevenueCatUserProvidable { get set }

  /// Responsible for updating the UI with changes to the purchase/restoration being made by the user.
  var subscriptionLoadingState: LoadingState { get }

  /// Fetches the available subscriptions and IAP's for the App.
  func fetchProducts()

  /// Purchases the selected subscription package or IAP.
  /// - Parameter productInformation: ProductInformation
  func purchasePackage(productInformation: ProductInformation) async throws

  /// Restores the Users purchase if applicable.
  func restorePurchases() async throws

  func logout()

  /// Attempts to refetch the available subscriptions or IAP"s if they are empty due to network issues etc.
  func observeNetworkStateAndFetchProductsIfNeeded()

  /// Used to monitor the state of the Users network connectivity.
  var networkMonitoringService: NetworkMonitoringService? { get set }

  /// Initalizes the SubscriptionClient
  /// - Parameters:
  ///   - productProvider: RevenueCatProductsProvidable
  ///   - userProvider: RevenueCatUserProvidable
  ///   - purchaseManager: RevenueCatPurchaseable
  ///   - networkMonitoringService: NetworkMonitoringService
  init(
    productProvider: RevenueCatProductsProvidable,
    userProvider: RevenueCatUserProvidable,
    purchaseManager: RevenueCatPurchaseable,
    networkMonitoringService: NetworkMonitoringService
  )
}
