//
//  PurchasePackageExampleApp.swift
//  PurchasePackageExample
//
//  Created by Josh Robbins on 3/27/24.
//

import PurchasePackage
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _: UIApplication,
    didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    AppManager.shared.configure(apiKey: "")
    return true
  }
}

@main
struct PurchasePackageExampleApp: App {

  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      PurchasesView()
        .accentColor(.white)
        .statusBarHidden(true)
        .preferredColorScheme(.dark)
    }
  }
}
