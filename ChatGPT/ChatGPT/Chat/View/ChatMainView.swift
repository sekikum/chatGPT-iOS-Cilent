//
//  ChatMainView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import Foundation
import SwiftUI

struct ChatMainView: View {
  @StateObject var viewModel: MessageViewModel
  let noTokenAdded: Bool
  let avatar: String
  
  var body: some View {
    VStack {
      ChatView(avatar: avatar, messageItems: viewModel.messageItems, isShowLoading: viewModel.isShowLoading)
      InputView(isShowAlert: $viewModel.isShowAlert, noTokenAdded: noTokenAdded, alertInfo: viewModel.alertInfo, send: viewModel.sendMessage, clear: viewModel.clearContext)
    }
    .padding()
  }
}

struct ChatMainView_Previews: PreviewProvider {
  static var previews: some View {
    ChatMainView(viewModel: MessageViewModel(), noTokenAdded: false, avatar: "Profile-Diu")
  }
}
