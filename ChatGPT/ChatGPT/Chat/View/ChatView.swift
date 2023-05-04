//
//  ChatView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import SwiftUI
import Combine

struct ChatView: View {
  let messageItems: [MessageModel]
  let avatar: String
  let messageTopPadding: CGFloat = 15
  
  var body: some View {
    ScrollViewReader { proxy in
      ScrollView() {
        ForEach(messageItems) { message in
          MessageView(userAvatar: avatar, message: message)
            .frame(width: UIScreen.main.bounds.size.width)
            .padding(.top, messageTopPadding)
            .id(message.id)
        }
        .frame(width: UIScreen.main.bounds.size.width)
      }
      .onReceive(keyboardPublisher) { value in
        if value {
          proxy.scrollTo(messageItems.last?.id, anchor: .bottom)
        }
      }
      .onTapGesture {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      }
      .scrollDismissesKeyboard(.immediately)
      .onAppear {
        proxy.scrollTo(messageItems.last?.id)
      }
      .onChange(of: messageItems) { newValue in
        proxy.scrollTo(newValue.last?.id)
      }
    }
  }
}

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView(messageItems: [MessageModel(message: "1+1=?", isUser: true), MessageModel(message: "2", isUser: false)], avatar: "Profile-User")
  }
}
