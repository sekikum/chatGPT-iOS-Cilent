//
//  ContentView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/3.
//

import SwiftUI

struct HomeView: View {
  @StateObject var userViewModel: UserViewModel = UserViewModel()
  @StateObject var messageViewModel: MessageViewModel = MessageViewModel()
  @State var selectionTab: HomeTab = .chat
  
  var body: some View {
    TabView(selection: $selectionTab) {
      ChatMainView(viewModel: messageViewModel, noTokenAdded: userViewModel.noTokenAdded, avatar: userViewModel.user.avatar)
        .tabItem {
          Label("Chat", systemImage: "message.fill")
        }
        .tag(HomeTab.chat)
      ProfileMainView(viewModel: userViewModel, initToken: messageViewModel.initOpenAI)
        .tabItem {
          Label("Me", systemImage: "person.fill")
        }
        .tag(HomeTab.me)
    }
  }
}

enum HomeTab {
  case chat
  case me
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
