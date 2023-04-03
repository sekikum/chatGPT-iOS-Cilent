//
//  ChatMainView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import SwiftUI

struct ChatMainView: View {
  @StateObject var viewModel: MessageViewModel
  let avatar: String
  @Binding var presentSideMenu: Bool
  
  var body: some View {
    VStack {
      ChatView(viewModel: viewModel, avatar: avatar)
      InputView(isShowAlert: $viewModel.isShowAlert, alertInfo: viewModel.alertInfo, send: viewModel.sendMessage, isShowLoading: viewModel.isShowLoading)
    }
    .navigationBarItems(leading: menuButton())
  }
  
  func menuButton() -> some View {
    VStack{
      HStack{
        Button{
          presentSideMenu.toggle()
        } label: {
          Image(systemName: "plus.bubble")
            .resizable()
            .frame(width: 20, height: 20)
            .padding(.top, 20)
        }
        Spacer()
      }      
    }
    .padding(.horizontal, 24)
  }
}

struct ChatMainView_Previews: PreviewProvider {
  static var previews: some View {
    ChatMainView(viewModel: MessageViewModel(), avatar: "Profile-User", presentSideMenu: .constant(true))
  }
}
