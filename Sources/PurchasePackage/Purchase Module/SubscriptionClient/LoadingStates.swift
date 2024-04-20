//
//  LoadingStates.swift
//  PurchasePackage
//
//  Created by Josh Robbins on 2/11/24.
//

import Foundation

/// Enum to represent the state of an asyncronous loading opetation
public enum LoadingState {
  /// Represents the initial state, indicating that no purchase operation is in progress or completed.
  case none

  /// Represents the state where a purchase operation is currently being processed.
  case loading

  /// Represents the state where a purchase operation has been completed successfully.
  case completed

  /// Represents the state where there was an error in the purchase operation.
  case error(String)
}
