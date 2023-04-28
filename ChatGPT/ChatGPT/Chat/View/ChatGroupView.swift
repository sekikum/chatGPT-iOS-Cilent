//
//  ChatGroupView.swift
//  ChatGPT
//
//  Created by cai dongyu on 2023/4/18.
//

import SwiftUI

struct ChatGroupView: View {
  @StateObject var viewModel: ChatGroupViewModel = ChatGroupViewModel()
  @State private var navigateToNewGroup = false
  let avatar: String
  let listPadding: CGFloat = 8
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.chatGroups, id: \.self) { group in
          if let flag = group.flag {
            NavigationLink {
              ChatMainView(viewModel: ChatMainViewModel(group: group, respository: viewModel.dataRespository), avatar: avatar)
            } label: {
              Label(flag, systemImage: "bubble.left")
            }
            .padding(.vertical, listPadding)
          }
        }
        .onDelete { indexSet in
          for index in indexSet {
            viewModel.deleteGroup(index)
          }
        }
      }
      .navigationTitle("Chat")
      .navigationBarTitleDisplayMode(.inline)
      .navigationDestination(isPresented: $navigateToNewGroup) {
        ChatMainView(viewModel: ChatMainViewModel(group: viewModel.chatGroups.last!, respository: viewModel.dataRespository), avatar: avatar)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            navigateToNewGroup = true
            viewModel.addGroup()
          }) {
            Image(systemName: "plus")
              .resizable()
          }
        }
      }
    }
  }
}

struct ChatGroupView_Previews: PreviewProvider {
  static var previews: some View {
    ChatGroupView(viewModel: ChatGroupViewModel(), avatar: "Profile-User")
  }
}
