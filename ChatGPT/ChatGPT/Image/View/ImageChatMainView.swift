//
//  ImageView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/24.
//

import SwiftUI

struct ImageChatMainView: View {
  @State var textField: String = ""
  @Binding var urlImages: [String]
  @Binding var isShowBrowser: Bool
  @Binding var selectImage: String
  @Binding var isShowAlert: Bool
  let alertInfo: String
  let avatar: String
  let number: Int
  let send: (String) -> Void
  let isShowLoading: Bool
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
        Button(action: sendPrompt) {
          Image(systemName: "paperplane.circle.fill")
            .resizable()
            .frame(width: buttonSize, height: buttonSize)
        }
        .disabled(isShowLoading || noTokenAdded)
        .alert(alertInfo, isPresented: $isShowAlert) {
          Button("OK", role: .cancel) { }
        }
        .overlay() {
          if isShowLoading {
            ProgressView()
          }
        }
        Spacer()
      }
      ImageView(isShowBrowser: $isShowBrowser, selectImage: $selectImage, urlImages: $urlImages)
      Spacer()
    }
    .background(
      Color("White")
        .onTapGesture {
          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    )
    .ignoresSafeArea(.keyboard, edges: .bottom)
  }
  
  func sendPrompt() {
    send(textField)
    textField = ""
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

struct ImageChatView_Previews: PreviewProvider {
  static var previews: some View {
    ImageChatMainView(urlImages: .constant([]), isShowBrowser: .constant(false), selectImage: .constant(""), isShowAlert: .constant(false), alertInfo: "",  avatar: "Profile-User", number: 3, send: {_ in}, isShowLoading: false)
  }
}
