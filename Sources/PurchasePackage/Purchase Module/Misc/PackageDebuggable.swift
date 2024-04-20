//
//  PackageDebuggable.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/9/24.
//

import Foundation

/// Protocol which determines if the package uses OSLog to monitor callbacks
public protocol PackageDebuggable {
  var allowsIOSDebugLog: Bool { get set }
}
