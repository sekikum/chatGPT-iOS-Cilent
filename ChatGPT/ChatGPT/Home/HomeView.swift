//
//  ContentView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/3.
//

import SwiftUI

struct HomeView: View {
  @State var selectionTab: HomeTab = .chat
  
  var body: some View {
    TabView(selection: $selectionTab) {
      ChatMainView()
        .tabItem {
          Label("Chat", systemImage: "message.fill")
        }
        .tag(HomeTab.chat)
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
