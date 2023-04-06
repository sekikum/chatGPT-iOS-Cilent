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
  let padding: CGFloat = 10
  let frameWidth: CGFloat = 20
  let frameHeight: CGFloat = 20
  let imagePadding: CGFloat = 20
  let buttonPadding: CGFloat = 24
  
  var body: some View {
    VStack {
      ChatView(viewModel: viewModel, avatar: avatar)
      InputView(isShowAlert: $viewModel.isShowAlert, alertInfo: viewModel.alertInfo, send: viewModel.sendMessage, isShowLoading: viewModel.isShowLoading)
    }
    .padding(.bottom, padding)
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
            .frame(width: frameWidth, height: frameHeight)
            .padding(.top, imagePadding)
        }
        Spacer()
      }      
    }
    .padding(.horizontal, buttonPadding)
  }
}

struct ChatMainView_Previews: PreviewProvider {
  static var previews: some View {
    ChatMainView(viewModel: MessageViewModel(), avatar: "Profile-User", presentSideMenu: .constant(true))
  }
}
