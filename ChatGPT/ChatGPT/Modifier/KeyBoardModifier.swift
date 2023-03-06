//
//  KeyBoardModifier.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import Foundation
import SwiftUI

struct ResignKeyboardOnDrag: ViewModifier {
  var gesture = DragGesture().onChanged { _ in
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  func body(content: Content) -> some View {
    content.gesture(gesture)
  }
}

struct ResignKeyboardOnTap: ViewModifier {
  var gesture = TapGesture().onEnded { _ in
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  func body(content: Content) -> some View {
    content.gesture(gesture)
  }
}

extension View {
  func dismissKeyboardByDrag() -> some View {
    return modifier(ResignKeyboardOnDrag())
  }
  
  func dismissKeyboardByTap() -> some View {
    return modifier(ResignKeyboardOnTap())
  }
}
