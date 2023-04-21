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
  
  @State private var presentAlert = false
  @State private var newTitle = ""
  
  var body: some View {
    VStack {
      ChatView(viewModel: viewModel, avatar: avatar)
      InputView(isShowAlert: $viewModel.isShowAlert, isStreamingMessage: $viewModel.isStreamingMessage, alertInfo: viewModel.alertInfo, send: viewModel.sendMessage, isShowLoading: viewModel.isShowLoading)
    }
    .padding(.bottom, padding)
    .navigationTitle((isCreateGroup ? "New Chat" : group?.flag) ?? "Unknown")
    .navigationBarItems(
      trailing:
        Menu {
          Button(action: {
            self.presentAlert.toggle()
          }) {
            Text("Change Title")
          }
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
    .alert("Change Title", isPresented: $presentAlert ,actions: {
      TextField("new title", text: $newTitle)
      Button("OK", action: {
        if let group = group {
          viewModel.modifyGroup(group: group, flag: newTitle)
        }
      })
      Button("Cancel", role: .cancel, action: {})
    }, message: {
      Text("input new title.")
    })
  }
}

struct ChatMainView_Previews: PreviewProvider {
  static var previews: some View {
    ChatMainView(viewModel: MessageViewModel(), avatar: "Profile-User")
  }
}
