//
//  ChatView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import Foundation
import SwiftUI

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
      .dismissKeyboardByDrag()
      .dismissKeyboardByTap()
      .onAppear {
        viewModel.loadMessage()
        DispatchQueue.main.async() {
          proxy.scrollTo(viewModel.messageItems[viewModel.messageItems.count - 1].id)
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
