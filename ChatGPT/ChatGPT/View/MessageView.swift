//
//  MessageView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import Foundation
import SwiftUI

struct MessageView: View {
  let message: MessageModel
  let avatarSize: CGFloat = 50
  let textCornerRadius: CGFloat = 10

  var body: some View {
    HStack(alignment: .top) {
      if message.isUser == true {
        Spacer()
        Text(message.message)
          .padding()
          .background(Color("Blue-Color"))
          .cornerRadius(10)
        Image("Profile-Diu")
          .resizable()
          .scaledToFit()
          .frame(width: avatarSize, height: avatarSize)
      } else {
        Image("Profile-ChatGPT")
          .resizable()
          .scaledToFit()
          .frame(width: avatarSize, height: avatarSize)
        Text(message.message)
          .padding()
          .background(Color("Gray-Color"))
          .cornerRadius(textCornerRadius)
        Spacer()
      }
    }
  }
}

struct MessageView_Previews: PreviewProvider {
  static var previews: some View {
    MessageView(message: MessageModel(message: "In the darkIn the darkIn the darkIn the darkIn the darkIn the darkIn the darkIn the darkIn the darkIn the darkIn the dark", isUser: true))
    MessageView(message: MessageModel(message: "", isUser: true))
    MessageView(message: MessageModel(message: "Viper ViperViper ViperViper ViperViper ViperViper ViperViper ViperViper ViperViper ViperViper ViperViper ViperViper ViperViper ViperViper ViperViper Viper", isUser: false))
  }
}
