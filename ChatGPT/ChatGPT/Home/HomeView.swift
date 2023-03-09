//
//  ContentView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/3.
//

import SwiftUI

struct HomeView: View {
  @StateObject var viewModel = MessageViewModel()
  
  var body: some View {
    VStack {
      ChatView(messageItems: viewModel.messageItems)
      InputView(sendCallback: viewModel.sendMessage)
    }
    .padding()
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
