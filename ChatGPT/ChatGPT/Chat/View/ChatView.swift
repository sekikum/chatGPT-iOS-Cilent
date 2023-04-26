//
//  ChatView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import SwiftUI
import Combine

struct ChatView: View {
  @StateObject var viewModel: ChatMainViewModel
  let avatar: String
  let messageTopPadding: CGFloat = 15
  
  var body: some View {
    ScrollViewReader { proxy in
      ScrollView() {
        ForEach(viewModel.messageItems) { message in
          MessageView(userAvatar: avatar, message: message)
            .frame(width: UIScreen.main.bounds.size.width)
            .padding(.top, messageTopPadding)
            .id(message.id)
        }
        .frame(width: UIScreen.main.bounds.size.width)
      }
      .onReceive(keyboardPublisher) { value in
        if value {
          proxy.scrollTo(viewModel.messageItems.last?.id, anchor: .bottom)
        }
      }
      .onTapGesture {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      }
      .scrollDismissesKeyboard(.immediately)
      .onAppear {
        proxy.scrollTo(viewModel.messageItems.last?.id)
      }
      .onChange(of: viewModel.messageItems) { newValue in
        proxy.scrollTo(newValue.last?.id)

      }
    }
  }
}

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView(viewModel: ChatMainViewModel(), avatar: "Profile-User")
  }
}
