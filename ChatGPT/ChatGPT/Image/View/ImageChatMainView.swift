//
//  ImageView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/24.
//

import SwiftUI

struct ImageChatMainView: View {
  @State var textField: String = ""
  let avatar: String
  let buttonSize: CGFloat = 30
  let textFieldLimit: Int = 4
  let cornerRadius: CGFloat = 6
  let padding: CGFloat = 6
  
  var body: some View {
    HStack {
      Image(avatar)
      TextField("", text: $textField, axis: .vertical)
        .lineLimit(textFieldLimit)
        .padding(padding)
        .background(Color("Gray"))
        .cornerRadius(cornerRadius)
        .keyboardType(.default)
        .disableAutocorrection(true)
        .autocapitalization(.none)
      Button(action: {}) {
        Image(systemName: "paperplane.circle.fill")
          .resizable()
          .frame(width: buttonSize, height: buttonSize)
      }
    }
  }
}

struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    ImageChatMainView(avatar: "Profile-User")
  }
}
