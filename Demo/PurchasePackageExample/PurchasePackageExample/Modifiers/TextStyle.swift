//
//  TextStyle.swift
//  PurchasePackageExample
//
//  Created by Josh Robbins on 3/27/24.
//

import SwiftUI

// MARK: - TextStyle

enum TextStyle {
  case header, title, general, button

  var font: Font {
    switch self {
    case .header:
      Font.system(size: 18, weight: .bold, design: .rounded)
    case .title, .button:
      Font.system(size: 14, weight: .semibold, design: .rounded)
    case .general:
      Font.system(size: 12, weight: .semibold, design: .rounded)
    }
  }

  var color: Color {
    switch self {
    case .button:
      .black
    default:
      .white
    }
  }
}

// MARK: - TextStyle View Modifier

struct TextStyleModifier: ViewModifier {
  var style: TextStyle

  func body(content: Content) -> some View {
    content
      .font(style.font)
      .foregroundColor(style.color)
  }
}

extension View {
  func textStyle(_ style: TextStyle) -> some View {
    modifier(TextStyleModifier(style: style))
  }
}
