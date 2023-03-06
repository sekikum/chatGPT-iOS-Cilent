//
//  KeyBoardModifier.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import Foundation
import SwiftUI

struct ResignKeyboardOnDragGesture: ViewModifier {
  var gestureDrag = DragGesture().onChanged { _ in
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  var gestureTap = TapGesture().onEnded { _ in
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  func body(content: Content) -> some View {
    content.gesture(gestureDrag)
    content.gesture(gestureTap)
  }
}

extension View {
  func dismissKeyboard() -> some View {
    return modifier(ResignKeyboardOnDragGesture())
  }
}
