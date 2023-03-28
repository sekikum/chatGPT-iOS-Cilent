//
//  ImageView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/24.
//

import SwiftUI

struct ImageChatMainView: View {
  @State var textField: String = ""
  @State var urlImages4: [String]
  @Binding var isShowBrowser: Bool
  @Binding var selectImage: String
  let avatar: String
  let number: Int
  let buttonSize: CGFloat = 30
  let textFieldLimit: Int = 4
  let cornerRadius: CGFloat = 6
  let padding: CGFloat = 6
  let noTokenAdded = StorageManager.restoreUser().tokenList.isEmpty
  
  var body: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        Image(avatar)
        TextField(noTokenAdded ? "Please add Token on 'me'" : "Input your message", text: $textField, axis: .vertical)
          .disabled(noTokenAdded)
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
        .disabled(noTokenAdded)
        Spacer()
      }
      ImageView(isShowBrowser: $isShowBrowser, selectImage: $selectImage, number: number, urlImages4: urlImages4)
        .scrollDismissesKeyboard(.immediately)
        .onTapGesture {
          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
      Spacer()
    }
    .ignoresSafeArea(.keyboard, edges: .bottom)
  }
}

struct ImageChatView_Previews: PreviewProvider {
  static var previews: some View {
    ImageChatMainView(urlImages4: [], isShowBrowser: .constant(false), selectImage: .constant(""), avatar: "Profile-User", number: 3)
  }
}
