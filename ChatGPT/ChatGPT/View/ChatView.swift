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
    ScrollView() {
      ForEach(viewModel.messageItems) { message in
        MessageView(message: message)
          .padding(.bottom, messageBottomPadding)
      }
    }
    .dismissKeyboardByDrag()
    .dismissKeyboardByTap()
    .onAppear {
      viewModel.loadMessage()
    }
  }
}

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView()
  }
}
