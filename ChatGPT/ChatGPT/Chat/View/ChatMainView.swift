//
//  ChatMainView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import SwiftUI

struct ChatMainView: View {
  @StateObject var viewModel: MessageViewModel
  let avatar: String
  let padding: CGFloat = 10
  var group: ChatGroup?
  var isCreateGroup: Bool = false

  var body: some View {
    VStack {
      ChatView(viewModel: viewModel, avatar: avatar)
      InputView(isShowAlert: $viewModel.isShowAlert, isStreamingMessage: $viewModel.isStreamingMessage, alertInfo: viewModel.alertInfo, send: viewModel.sendMessage, isShowLoading: viewModel.isShowLoading)
    }
    .padding(.bottom, padding)
    .navigationTitle((isCreateGroup ? "New Chat" : group?.flag) ?? "Unknown")
    .navigationBarItems(trailing: Menu {
      Button(action: viewModel.clearContext) {
        Text("Clear")
        Image(systemName: "xmark.circle")
      }
    } label: {
      Image(systemName: "ellipsis")
    })
      .onAppear {
      if isCreateGroup {
        viewModel.clearScreen()
        viewModel.addGroup()
      } else {
        if let group = group {
          viewModel.setCurrentChat(group)
        }
      }
    }
  }
}

struct ChatMainView_Previews: PreviewProvider {
  static var previews: some View {
    ChatMainView(viewModel: MessageViewModel(), avatar: "Profile-User")
  }
}
