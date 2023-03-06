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
    MessageView(message: MessageModel(message: "mysql输入框怎么退出", isUser: true))
    MessageView(message: MessageModel(message: "在MySQL命令行输入框中，如果您想要退出，请执行以下步骤：\n1. 输入quit并按下回车键。(如果您正在编辑或输入一条命令，按下Ctrl+C可以取消命令并返回到命令行提示符)\n2. 如果您需要强制退出，请按下Ctrl+D键，这将关闭MySQL命令行并返回到系统命令行提示符。\n请注意，以上步骤可能会因使用的操作系统和MySQL版本而略有不同。", isUser: false))
  }
}
