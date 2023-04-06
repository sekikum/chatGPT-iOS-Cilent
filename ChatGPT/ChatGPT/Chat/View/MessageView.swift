//
//  MessageView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import SwiftUI
import Splash
import MarkdownUI

struct MessageView: View {
  @Environment(\.colorScheme) private var colorScheme
  let userAvatar: String
  let message: MessageModel
  let avatarSize: CGFloat = 50
  let textCornerRadius: CGFloat = 10
  let avatarCornerRadius: CGFloat = 5
  let padding: CGFloat = 15
  let fontSize: Double = 16
  let spacing: CGFloat = -10

  var body: some View {
    HStack(alignment: .top, spacing: spacing) {
      if message.isUser == true {
        Spacer()
        ChatBubble(triangleDirection: .right, color: Color("Blue"), avatar: avatarSize) {
          Markdown(message.message)
            .padding()
            .background(Color("Blue"))
            .cornerRadius(textCornerRadius)
            .textSelection(.enabled)
            .markdownCodeSyntaxHighlighter(.splash(theme: self.theme))
        }
        Image(userAvatar)
          .resizable()
          .scaledToFit()
          .cornerRadius(avatarCornerRadius)
          .frame(width: avatarSize, height: avatarSize)
          .padding(.trailing, padding)
      } else {
        Image("Profile-ChatGPT")
          .resizable()
          .scaledToFit()
          .cornerRadius(avatarCornerRadius)
          .frame(width: avatarSize, height: avatarSize)
          .padding(.leading, padding)
        ChatBubble(triangleDirection: .left, color: Color("Blue"), avatar: avatarSize) {
          Markdown(message.message)
            .padding()
            .background(Color("Gray"))
            .cornerRadius(textCornerRadius)
            .textSelection(.enabled)
            .markdownCodeSyntaxHighlighter(.splash(theme: self.theme))
        }
        Spacer()
      }
    }
  }

  private var theme: Splash.Theme {
    switch self.colorScheme {
    case .dark:
      return .wwdc17(withFont: .init(size: fontSize))
    default:
      return .sunset(withFont: .init(size: fontSize))
    }
  }
}

struct MessageView_Previews: PreviewProvider {
  static var previews: some View {
    MessageView(userAvatar: "Profile-User", message: MessageModel(message: "mysql输入框怎么退出", isUser: true))
    MessageView(userAvatar: "Profile-User", message: MessageModel(message: "在MySQL命令行输入框中，如果您想要退出，请执行以下步骤：\n1. 输入quit并按下回车键。(如果您正在编辑或输入一条命令，按下Ctrl+C可以取消命令并返回到命令行提示符)\n2. 如果您需要强制退出，请按下Ctrl+D键，这将关闭MySQL命令行并返回到系统命令行提示符。\n请注意，以上步骤可能会因使用的操作系统和MySQL版本而略有不同。", isUser: false))
  }
}
