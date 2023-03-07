//
//  ChatView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import Foundation
import SwiftUI
import Combine

struct ChatView: View {
  @StateObject var viewModel = MessageViewModel()
  let messageBottomPadding: CGFloat = 15
  
  var body: some View {
    ScrollViewReader { proxy in
      ScrollView() {
        ForEach(viewModel.messageItems) { message in
          MessageView(message: message)
            .frame(width: UIScreen.main.bounds.size.width)
            .padding(.bottom, messageBottomPadding)
            .id(message.id)
        }
      }
      .onReceive(keyboardPublisher) { value in
        if value {
          proxy.scrollTo(viewModel.messageItems.last?.id, anchor: .bottom)
        }
      }
      .scrollDismissesKeyboard(.immediately)
      .onTapGesture {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      }
      .onAppear {
        viewModel.loadMessage()
        DispatchQueue.main.async() {
          proxy.scrollTo(viewModel.messageItems.last?.id)
        }
      }
    }
  }
}

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView()
  }
}
