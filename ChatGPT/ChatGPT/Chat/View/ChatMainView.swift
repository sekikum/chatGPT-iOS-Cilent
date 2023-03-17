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
  
  var body: some View {
    VStack {
      ChatView(avatar: avatar, messageItems: viewModel.messageItems)
      InputView(isShowAlert: $viewModel.isShowAlert, alertInfo: viewModel.alertInfo, send: viewModel.sendMessage, clear: viewModel.clearContext, isShowLoading: viewModel.isShowLoading)
    }
    .padding()
  }
}

struct ChatMainView_Previews: PreviewProvider {
  static var previews: some View {
    ChatMainView(viewModel: MessageViewModel(), avatar: "Profile-Diu")
  }
}
