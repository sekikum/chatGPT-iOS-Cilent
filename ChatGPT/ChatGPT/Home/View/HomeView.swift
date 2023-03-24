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
      NavigationView {
        ChatMainView(viewModel: messageViewModel, avatar: userViewModel.user.avatar)
          .navigationBarItems(trailing: Menu {
            Button(action: messageViewModel.clearContext) {
              Text("Clear")
              Image(systemName: "xmark.circle.fill")
            }
          } label: {
            Image(systemName: "ellipsis")
              .padding(.top, 1)
          })
      }
      .tabItem {
        Label("Chat", systemImage: "message.fill")
      }
      .tag(HomeTab.chat)
      
      ImageChatMainView()
        .tabItem {
          Label("Image", systemImage: "photo.circle.fill")
        }
        .tag(HomeTab.image)
      
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
  case image
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
