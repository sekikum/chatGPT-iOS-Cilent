//
//  ChatView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import SwiftUI
import Combine

struct ChatView: View {
  @ObservedObject var viewModel: MessageViewModel
  let avatar: String
  let messageBottomPadding: CGFloat = 15
  
  var body: some View {
    ScrollViewReader { proxy in
      ScrollView() {
        LazyVStack{
          ForEach(viewModel.messageItems) { message in
            MessageView(userAvatar: avatar, message: message)
              .frame(width: UIScreen.main.bounds.size.width)
              .padding(.bottom, messageBottomPadding)
              .id(message.id)
          }
        }
        .frame(width: UIScreen.main.bounds.size.width)
      }
      .onReceive(keyboardPublisher) { value in
        if value {
          proxy.scrollTo(viewModel.messageItems.last?.id, anchor: .bottom)
        }
      }
      .onTapGesture {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      }
      .onAppear {
        proxy.scrollTo(viewModel.messageItems.last?.id)
      }
      .onChange(of: viewModel.messageItems) { newValue in
        proxy.scrollTo(newValue.last?.id)
      }
    }
  }
}

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView(viewModel: MessageViewModel(), avatar: "Profile-User")
    //    , messageItems: [
    //      MessageModel(message: "mysql输入框怎么退出", isUser: true),
    //      MessageModel(message: "在MySQL命令行输入框中，如果您想要退出，请执行以下步骤：\n1. 输入quit并按下回车键。(如果您正在编辑或输入一条命令，按下Ctrl+C可以取消命令并返回到命令行提示符)\n2. 如果您需要强制退出，请按下Ctrl+D键，这将关闭MySQL命令行并返回到系统命令行提示符。\n请注意，以上步骤可能会因使用的操作系统和MySQL版本而略有不同。", isUser: false)
    //    ])
  }
}
