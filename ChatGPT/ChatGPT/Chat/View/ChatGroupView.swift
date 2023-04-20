//
//  ChatGroupView.swift
//  ChatGPT
//
//  Created by cai dongyu on 2023/4/18.
//

import SwiftUI

struct ChatGroupView: View {
  @StateObject var viewModel: MessageViewModel
  let avatar: String
  let listPadding: CGFloat = 8
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.chatGroups, id: \.self) { group in
          if let flag = group.flag {
            NavigationLink {
              ChatMainView(viewModel: viewModel, avatar: avatar, group: group)
            } label: {
              Label(flag, systemImage: "bubble.left")
            }
            .padding(.vertical, 8)
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
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          NavigationLink(destination: ChatMainView(viewModel: viewModel, avatar: avatar, group: nil, isCreateGroup: true)) {
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
    ChatGroupView(viewModel: MessageViewModel(), avatar: "1")
  }
}
