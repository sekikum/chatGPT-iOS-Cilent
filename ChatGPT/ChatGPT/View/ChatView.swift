//
//  ChatView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import Foundation
import SwiftUI

struct ChatView: View {
  var body: some View {
    ScrollView {
      
    }
    .dismissKeyboardByDrag()
    .dismissKeyboardByTap()
  }
}

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView()
  }
}
