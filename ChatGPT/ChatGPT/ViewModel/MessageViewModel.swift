//
//  MessageViewModel.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import Foundation
import OpenAISwift

class MessageViewModel: ObservableObject {
  @Published var messageItems: [MessageModel] = []
  var chatMessageItems: [ChatMessage] = [
    ChatMessage(role: .user, content: "mysql输入框怎么退出"),
    ChatMessage(role: .system, content: "在MySQL命令行输入框中，如果您想要退出，请执行以下步骤：\n1. 输入quit并按下回车键。(如果您正在编辑或输入一条命令，按下Ctrl+C可以取消命令并返回到命令行提示符)\n2. 如果您需要强制退出，请按下Ctrl+D键，这将关闭MySQL命令行并返回到系统命令行提示符。\n请注意，以上步骤可能会因使用的操作系统和MySQL版本而略有不同。"),
    ChatMessage(role: .user, content: "在macos停掉本地mysql"),
    ChatMessage(role: .system, content: "打开终端 (Terminal) 应用程序。\n运行以下命令以停止 MySQL 服务：\nsudo /usr/local/mysql/support-files/mysql.server stop\n如果你安装了 MySQL 并将其放置在不同的位置，请相应地更改命令中的路径。\n\n在 Linux 上，可以使用以下命令停止 MySQL 服务：\nsudo systemctl stop mysql\n请注意，这些命令可能需要以管理员权限运行。"),
    ChatMessage(role: .user, content: "管理员权限输入密码是什么密码"),
    ChatMessage(role: .system, content: "管理员权限需要输入的密码是你当前操作系统的管理员密码。这通常是在你安装操作系统时设置的密码。如果你没有设置管理员密码，或者不确定密码是什么，可以尝试使用当前用户的密码或空密码来尝试。如果这些方法都不起作用，你可能需要重置管理员密码。具体操作方式可能因操作系统而异，你可以在操作系统文档或者相关技术支持网站上查找更多信息。")
  ]
  
  init() {
    loadMessage()
  }
  
  func loadMessage() {
    messageItems = chatMessageItems.map({ chatMessage in
      if chatMessage.role == .user {
        return MessageModel(message: chatMessage.content, isUser: true)
      }
      return MessageModel(message: chatMessage.content, isUser: false)
    })
  }
  
  func sendMessage(_ message: String) {
    messageItems.append(MessageModel(message: message, isUser: true))
    let chatMessage = ChatMessage(role: .user, content: message)
    chatMessageItems.append(chatMessage)
  }
}
