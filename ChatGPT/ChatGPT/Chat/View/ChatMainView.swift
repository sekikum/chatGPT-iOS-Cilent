//
//  ChatMainView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import SwiftUI

struct ChatMainView: View {
  @EnvironmentObject var viewModel: MessageViewModel
  let avatar: String
  @Binding var presentSideMenu: Bool
  
  var body: some View {
    VStack {
      ChatView(avatar: avatar)
        .environmentObject(viewModel)
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
                  Image(systemName: "sidebar.left")
                      .resizable()
                      .frame(width: 30, height: 24)
                      .padding(.top, 20)
              }
              Spacer()
          }

          Spacer()
          Spacer()
      }
      .padding(.horizontal, 24)
  }
}

struct ChatMainView_Previews: PreviewProvider {
  static var previews: some View {
    ChatMainView(avatar: "Profile-User", presentSideMenu: .constant(true))
  }
}
