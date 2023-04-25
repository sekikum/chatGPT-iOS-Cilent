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
  @State var promptTemp: String = ""
  let avatar: String
  let padding: CGFloat = 10
  let subtitleLineLimit: Int = 1
  var group: ChatGroup?
  var isCreateGroup: Bool = false

  var body: some View {
    VStack {
      ChatView(viewModel: viewModel, avatar: avatar)
      InputView(viewModel: viewModel.makeInputViewModel())
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
    .toolbarBackground(.visible, for: .navigationBar)
    .navigationBarItems(trailing: Menu {
      Button(action: viewModel.clearContext) {
        Text("Clear")
        Image(systemName: "xmark.circle")
      }
      Button(action: {
        isShowSetPrompt = true
        promptTemp = prompt
      }) {
        Text("Prompt")
        Image(systemName: "pencil.circle")
      }
    } label: {
      Image(systemName: "ellipsis")
    })
    .alert("Set Prompt", isPresented: $isShowSetPrompt, actions: {
      TextField("Input prompt", text: $prompt)
        .onAppear {
          UITextField.appearance().clearButtonMode = .whileEditing
        }
      Button("OK", action: {
        viewModel.savePrompt()
        UITextField.appearance().clearButtonMode = .never
      })
      Button("Cancel", role: .cancel, action: {
        prompt = promptTemp
        UITextField.appearance().clearButtonMode = .never
      })
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
