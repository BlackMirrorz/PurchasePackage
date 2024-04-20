//
//  PurchasesView.swift
//  PurchasePackageExample
//
//  Created by Josh Robbins on 3/27/24.
//

import PurchasePackage
import SwiftUI

struct PurchasesView: View {

  @State var refresher: UUID = .init()

  @State var isAppleSubscriber = false

  @ObservedObject
  var viewModel = SubscriptionClient(
    productProvider: AppManager.shared.subscriptionManager.productProvider,
    userProvider: AppManager.shared.subscriptionManager.userProvider,
    purchaseManager: AppManager.shared.subscriptionManager.purchaseManager
  )

  var body: some View {
    NavigationView {
      ZStack {
        Color.black.ignoresSafeArea(.all)
        loadingView
        VStack {
          productView
          purchaseView
        }
      }.toolbar {
        ToolbarItem(placement: .principal) {
          Text("Available Products").textStyle(.header)
        }
      }.background(Color.clear)
    }.onAppear {
      viewModel.fetchProducts()
      getStatus()
    }
  }

  // MARK: - Views

  @ViewBuilder
  private var loadingView: some View {
    switch viewModel.productLoadingState {
    case .none:
      EmptyView()
    case .loading:
      progressView(text: "Fetching Subscriptions")
    case .completed:
      EmptyView()
    case .error(let text):
      progressView(text: text)
    }
  }

  @ViewBuilder
  private var purchaseView: some View {
    ZStack {
      VStack {
        switch viewModel.subscriptionLoadingState {
        case .none:
          EmptyView()
        case .loading:
          progressView(text: "Processing Subscription")
        case .completed:
          progressView(text: "Your transaction has completed")
        case .error(let text):
          progressView(text: text)
        }
        VStack {
          Spacer()
//          Text("""
//          User is Apple Subscriber \(isAppleSubscriber)
//          User is Ultimate User \(isUltimateUser)
//          """)
//          .id(refresher)
            .textStyle(.general)
            .multilineTextAlignment(.center)
            .padding(.bottom, 16)
          button(title: "Restore Purchases", action: restorePurchases)
          button(title: "Logout", action: logout)
            .padding(.bottom, 16)
        }
      }
    }
  }

  @ViewBuilder
  private func progressView(text: String) -> some View {
    ProgressView {
      Text(text).textStyle(.general)
    }.tint(.white)
  }

  @ViewBuilder
  private var productView: some View {
    List(viewModel.availableProducts, id: \.identifier) { product in

      VStack(alignment: .leading) {

        if product.isEligibleForTrial, let trialText = product.freeTrialMessageText {
          Text(trialText).textStyle(.title)
        }
        Text(product.subscriptionDisplayName).textStyle(.title)
        Text(product.productIdentifier).textStyle(.general)
        Text(product.pricingDisplayText).textStyle(.general).onTapGesture {}
      }
      .contentShape(Rectangle())
      .onTapGesture { purchase(product) }
      .listRowBackground(Color.clear)
    }.listStyle(.plain)
      .scrollContentBackground(.hidden)
      .navigationBarTitleDisplayMode(.inline)
  }

  private func button(title: String, action: @escaping () -> Void) -> some View {
    Button(
      action: action,
      label: {
        ZStack {
          RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).fill(Color.white)
          Text(title).textStyle(.button)
        }
      }
    )
    .frame(height: 40)
    .buttonStyle(.plain)
  }

  // MARK: - Callbacks

  private func purchase(_ product: ProductInformation) {
    Task(priority: .userInitiated) {
      do {
        try await self.viewModel.purchasePackage(productInformation: product)
        getStatus()
      } catch {}
    }
  }

  private func restorePurchases() {
    Task(priority: .userInitiated) {
      do {
        try await self.viewModel.restorePurchases()
        getStatus()
      } catch {}
    }
  }

  private func logout() {
    viewModel.logout()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      getStatus()
    }
  }

  func getStatus() {
    DispatchQueue.main.async {
      isAppleSubscriber = AppManager.shared.isAppleSubscriber
    }
  }
}

// MARK: - Preview

#Preview {
  ZStack {
    Color.black.ignoresSafeArea(.all)
    PurchasesView()
  }
}
