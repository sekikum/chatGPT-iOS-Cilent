//
//  ChatMainView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import SwiftUI

struct ChatMainView: View {
  @StateObject var viewModel: MessageViewModel
  @Binding var prompt: String
  @State var isShowSetPrompt: Bool = false
  let avatar: String
  let padding: CGFloat = 10
  let subtitleLineLimit: Int = 1
  var group: ChatGroup?
  var isCreateGroup: Bool = false

  var body: some View {
    VStack {
      ChatView(viewModel: viewModel, avatar: avatar)
      InputView(isShowAlert: $viewModel.isShowAlert, isStreamingMessage: $viewModel.isStreamingMessage, alertInfo: viewModel.alertInfo, send: viewModel.sendMessage, isShowLoading: viewModel.isShowLoading)
    }
    .padding(.bottom, padding)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .principal) {
        VStack {
          Text((isCreateGroup ? "New Chat" : group?.flag) ?? "Unknown")
            .font(.headline)
          if !prompt.isEmpty {
            Text(prompt)
              .font(.subheadline)
              .foregroundColor(.secondary)
              .lineLimit(subtitleLineLimit)
          }
        }
      }
    }
    .navigationBarItems(trailing: Menu {
      Button(action: viewModel.clearContext) {
        Text("Clear")
        Image(systemName: "xmark.circle")
      }
      Button(action: {
        isShowSetPrompt = true
      }) {
        Text("Prompt")
        Image(systemName: "pencil.circle")
      }
    } label: {
      Image(systemName: "ellipsis")
    })
    .alert("Set Prompt", isPresented: $isShowSetPrompt, actions: {
      TextField("Input prompt", text: $prompt)
      Button("OK", action: {
        viewModel.savePrompt()
      })
      Button("Cancel", role: .cancel, action: {})
    }, message: {
      Text("What do you want chatGPT to do")
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
    ChatMainView(viewModel: MessageViewModel(), prompt: .constant(""), avatar: "Profile-User")
  }
}
