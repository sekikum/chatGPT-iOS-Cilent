//
//  ChatBubbleView.swift
//  ChatGPT
//
//  Created by cai dongyu on 2023/4/6.
//

import Foundation

enum BubblePosition {
  case right
  case left
}

struct ChatBubble<Content>: View where Content: View {
  let position: BubblePosition
  let color : Color
  let paddingSize: CGFloat = 10
  let spacing: CGFloat = 0
  let offsetX: CGFloat = 9
  let angleDegrees: CGFloat = 180
  let content: () -> Content
  let cornerRadiu: CGFloat = 5
  let triHeight: CGFloat = 5
  let avatar: CGFloat
  init(position: BubblePosition,
       color: Color,
       avatar: CGFloat,
       @ViewBuilder content: @escaping () -> Content) {
    self.position = position
    self.color = color
    self.content = content
    self.avatar = avatar
  }

  var body: some View {
    HStack(alignment: .top, spacing: spacing ) {
      if position == .left {
        Image(systemName: "arrowtriangle.left.fill")
          .frame(height: triHeight)
          .foregroundColor(color)
          .offset(x: offsetX)
          .offset(y: 0)
      }
      content()
        .foregroundColor(Color.white)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadiu))

      if position == .right {
        Image(systemName: "arrowtriangle.left.fill")
          .frame(height: triHeight)
          .foregroundColor(color)
          .rotationEffect(Angle(degrees: angleDegrees))
          .offset(x: -offsetX)
          .offset(y: (avatar - triHeight) / 2)
      }
    }
    .padding(position == .left ? .leading : .trailing , paddingSize)

