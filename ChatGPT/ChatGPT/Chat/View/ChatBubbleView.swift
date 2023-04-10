//
//  ChatBubbleView.swift
//  ChatGPT
//
//  Created by cai dongyu on 2023/4/6.
//

import Foundation
import SwiftUI

enum Direction {
  case left
  case right
}

struct ChatBubble<Content>: View where Content: View {
  let triangleDirection: Direction
  let color: Color
  let paddingSize: CGFloat = 10
  let spacing: CGFloat = 0
  let imageOffsetX: CGFloat = 9
  let angleDegrees: CGFloat = 180
  let content: () -> Content
  let cornerRadiu: CGFloat = 5
  let triHeight: CGFloat = 5
  let avatar: CGFloat
  init(triangleDirection: Direction,
       color: Color,
       avatar: CGFloat,
       @ViewBuilder content: @escaping () -> Content) {
    self.triangleDirection = triangleDirection
    self.color = color
    self.content = content
    self.avatar = avatar
  }
  
  var body: some View {
    HStack(alignment: .top, spacing: spacing ) {
      if triangleDirection == .left {
        Image(systemName: "arrowtriangle.left.fill")
          .frame(height: triHeight)
          .foregroundColor(color)
          .offset(x: imageOffsetX)
          .offset(y: avatar / 2)
      }
      content()
        .foregroundColor(Color.white)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadiu))
      if triangleDirection == .right {
        Image(systemName: "arrowtriangle.left.fill")
          .frame(height: triHeight)
          .foregroundColor(color)
          .rotationEffect(Angle(degrees: angleDegrees))
          .offset(x: -imageOffsetX)
          .offset(y: avatar / 2)
      }
    }
    .padding(triangleDirection == .left ? .leading : .trailing , paddingSize)
  }
}
