//
//  ChatMainView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import SwiftUI

struct ChatMainView: View {
  @StateObject var viewModel: ChatMainViewModel
  @State var isShowSetPrompt: Bool = false
  @State var promptTemp: String = ""
  let avatar: String
  let padding: CGFloat = 10
  let subtitleLineLimit: Int = 1
  var isCreateGroup: Bool = false

  var body: some View {
    VStack {
      ChatView(messageItems: viewModel.messageItems, avatar: avatar)
      InputView(viewModel: InputViewModel(isStreaming: viewModel.isStreamingMessage, isShowLoading: viewModel.isShowLoading, send: viewModel.sendMessage(_:_:), cancel: viewModel.cancelStreaming))
    }
    .padding(.bottom, padding)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .principal) {
        VStack {
          Text(viewModel.getGroupTitle())
            .font(.headline)
          if !viewModel.prompt.isEmpty {
            Text(viewModel.prompt)
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
        promptTemp = viewModel.prompt
      }) {
        Text("Prompt")
        Image(systemName: "pencil.circle")
      }
    } label: {
      Image(systemName: "ellipsis")
    })
    .alert("Set Prompt", isPresented: $isShowSetPrompt, actions: {
      TextField("Input prompt", text: $viewModel.prompt)
        .onAppear {
          UITextField.appearance().clearButtonMode = .whileEditing
        }
      Button("OK", action: {
        viewModel.savePrompt()
        UITextField.appearance().clearButtonMode = .never
      })
      Button("Cancel", role: .cancel, action: {
        viewModel.prompt = promptTemp
        UITextField.appearance().clearButtonMode = .never
      })
    }, message: {
      Text("What do you want chatGPT to do")
    })
    .alert(viewModel.alertInfo, isPresented: $viewModel.isShowAlert) {
      Button("OK", role: .cancel) { }
    }
    .toolbar(.hidden, for: .tabBar)
  }
}

struct ChatMainView_Previews: PreviewProvider {
  static var previews: some View {
    ChatMainView(viewModel: ChatMainViewModel(group: ChatGroup(), repository: CoreDataRepository()), avatar: "")
  }
}
