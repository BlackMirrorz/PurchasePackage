//
//  SubscriptionClient.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/11/24.
//

import Combine
import Foundation
import NetworkingLayer

/**
 Responsible for the orchestration of in-app purchases (IAP) and subscription management within your application.
  - Implements `SubscriptionClientConfigurable` for a structured approach to subscription and IAP management.
  - Uses `NetworkMonitoringService` for real-time network state monitoring.
  - Employs `RevenueCatProductsProvidable` and `RevenueCatPurchaseable` protocols to interact with RevenueCat's SDK.
  It is recommended that it is used in conjunction with the `AppManager`although this is not necessary.
  */
public class SubscriptionClient: SubscriptionClientConfigurable, ObservableObject {

  @Published public var subscriptionLoadingState: LoadingState = .none

  @Published public var productLoadingState: LoadingState = .loading

  @Published public var availableProducts: [ProductInformation] = []

  public weak var networkMonitoringService: NetworkMonitoringService?

  public var productProvider: RevenueCatProductsProvidable

  public var purchaseManager: RevenueCatPurchaseable

  public var userProvider: RevenueCatUserProvidable

  private var cancelBag = Set<AnyCancellable>()

  // MARK: - Initialization

  public required init(
    productProvider: RevenueCatProductsProvidable,
    userProvider: RevenueCatUserProvidable,
    purchaseManager: RevenueCatPurchaseable,
    networkMonitoringService: NetworkMonitoringService = NetworkMonitoringService()
  ) {
    self.productProvider = productProvider
    self.userProvider = userProvider
    self.purchaseManager = purchaseManager
    self.networkMonitoringService = networkMonitoringService
    observeNetworkStateAndFetchProductsIfNeeded()
  }
}

// MARK: - Purchases

extension SubscriptionClient {

  public func observeNetworkStateAndFetchProductsIfNeeded() {
    networkMonitoringService?.$networkState.sink { [weak self] state in
      guard
        let self = self,
        state == .connected,
        self.productProvider.availableProducts.isEmpty
      else {
        return
      }
      self.fetchProducts()
    }.store(in: &cancelBag)
  }

  public func fetchProducts() {
    setProductLoadingState(.loading)
    Task {
      do {
        let offeringData = try await productProvider.getOfferingAndAssociatedProducts()
        await MainActor.run {
          self.availableProducts = offeringData.products
          self.setProductLoadingState(.completed)
        }
      } catch {
        await MainActor.run {
          self.setProductLoadingState(.error("Unable to fetch subscriptions."))
          self.availableProducts = []
        }
      }
    }
  }

  public func purchasePackage(productInformation: ProductInformation) async throws {
    setSubscriptionLoadingState(.loading)
    do {
      try await purchaseManager.purchasePackage(productInformation: productInformation)
      _ = try await userProvider.getCustomerInformation()
      await setStateAndReset(.completed)
    } catch let error as RevenueCatError {
      await setStateAndReset(.error(error.message))
      throw error
    }
  }

  public func restorePurchases() async throws {
    setSubscriptionLoadingState(.loading)

    do {
      try await purchaseManager.restorePurchases()
      _ = try await userProvider.getCustomerInformation()
      await setStateAndReset(.completed)
    } catch let error as RevenueCatError {
      await setStateAndReset(.error(error.message))
      throw error
    }
  }

  public func logout() {
    AppManager.shared.logout()
  }
}

// MARK: - Loading States

extension SubscriptionClient {

  /// Sets the loading states and applies a 2 second delay before resetting the state to .none
  /// - Parameter state: LoadingState
  private func setStateAndReset(_ state: LoadingState) async {
    setSubscriptionLoadingState(state)
    try? await Task.sleep(nanoseconds: 2_000_000_000)
    setSubscriptionLoadingState(.none)
  }

  /// Sets the subscriptionLoadingState
  /// - Parameter subscriptionLoadingState: LoadingState
  private func setSubscriptionLoadingState(_ subscriptionLoadingState: LoadingState) {
    DispatchQueue.main.async {
      self.subscriptionLoadingState = subscriptionLoadingState
    }
  }

  /// Sets the productLoadingState
  /// - Parameter productLoadingState: LoadingState
  private func setProductLoadingState(_ productLoadingState: LoadingState) {
    DispatchQueue.main.async {
      self.productLoadingState = productLoadingState
    }
  }
}
