//
//  ImageView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/24.
//

import SwiftUI

struct ImageChatMainView: View {
  @StateObject var viewModel: ImageViewModel
  @State var textField: String = ""
  @Binding var isShowBrowser: Bool
  @Binding var selectImage: Int
  @Binding var images: [Image]
  let avatar: String
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
        .disabled(viewModel.isShowLoading || noTokenAdded)
        .alert(viewModel.alertInfo, isPresented: $viewModel.isShowAlert) {
          Button("OK", role: .cancel) { }
        }
        .overlay() {
          if viewModel.isShowLoading {
            ProgressView()
          }
        }
        Spacer()
      }
      ImageView(isShowBrowser: $isShowBrowser, selectImage: $selectImage, urlImages: $viewModel.imagesURL, images: $images)
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
    viewModel.sendPrompt(textField)
    textField = ""
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

struct ImageChatView_Previews: PreviewProvider {
  static var previews: some View {
    ImageChatMainView(viewModel: ImageViewModel(), isShowBrowser: .constant(false), selectImage: .constant(1), images: .constant([]), avatar: "")
  }
}
