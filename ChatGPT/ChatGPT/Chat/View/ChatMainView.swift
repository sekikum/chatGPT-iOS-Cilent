//
//  ChatMainView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import Foundation
import SwiftUI

struct ChatMainView: View {
  @StateObject var viewModel = MessageViewModel()
  
  var body: some View {
    VStack {
      ChatView(messageItems: viewModel.messageItems)
      InputView(sendCallback: viewModel.sendMessage)
    }
    .padding()
  }
}

struct ChatMainView_Previews: PreviewProvider {
  static var previews: some View {
    ChatMainView()
  }
}
