//
//  ContentView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/3.
//

import SwiftUI

struct HomeView: View {
  @State var selectionTab: HomeTab = .chat
  @StateObject var viewModel: HomeViewModel = HomeViewModel()
  
  var body: some View {
    TabView(selection: $selectionTab) {
      ChatMainView()
        .tabItem {
          Label("Chat", systemImage: "message.fill")
        }
        .tag(HomeTab.chat)
      ProfileMainView()
        .tabItem {
          Label("Me", systemImage: "person.fill")
        }
        .tag(HomeTab.me)
    }
    .environmentObject(viewModel)
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
