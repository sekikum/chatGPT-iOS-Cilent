//
//  SideMenu.swift
//  ChatGPT
//
//  Created by cai dongyu on 2023/3/29.
//

import SwiftUI

struct SideMenu: View {
  @Binding var isShowing: Bool
  var content: AnyView
  var edgeTransition: AnyTransition = .move(edge: .leading)
  let opacity: CGFloat = 0.8

  var body: some View {
    ZStack(alignment: .bottom) {
      if isShowing {
        Color.black
          .opacity(opacity)
          .onTapGesture {
            isShowing.toggle()
          }
        content
          .transition(edgeTransition)
          .background(
            Color.clear
          )
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    .ignoresSafeArea()
    .animation(.easeInOut, value: isShowing)
  }
}
