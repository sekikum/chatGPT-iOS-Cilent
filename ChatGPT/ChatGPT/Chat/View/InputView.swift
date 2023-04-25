//
//  InputView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import SwiftUI

struct InputViewModel {
  let send: (String, String) -> Void
  let isShowLoading: Bool
  let placeholder: String
  let buttonImage: String
  let isTextFieldDisable: Bool
  let setButtonAction: (() -> Void) -> Void
  let isButtonDisable: Bool
}

struct InputView: View {
  @State var textfieldText: String = ""
  let viewModel: InputViewModel
  let padding: CGFloat = 6
  let cornerRadius: CGFloat = 6
  let textFieldLimit = 4
  let buttonSize: CGFloat = 30
  
  var body: some View {
    HStack {
      Spacer()
      TextField(viewModel.placeholder, text: $textfieldText, axis: .vertical)
        .disabled(viewModel.isTextFieldDisable)
        .lineLimit(textFieldLimit)
        .padding(padding)
        .background(Color("Gray"))
        .cornerRadius(cornerRadius)
        .keyboardType(.default)
        .disableAutocorrection(true)
        .autocapitalization(.none)
      Button(action: setButtonAction) {
        Image(systemName: viewModel.buttonImage)
          .resizable()
          .frame(width: buttonSize, height: buttonSize)
      }
      .overlay() {
        if viewModel.isShowLoading {
          ProgressView()
        }
      }
      .disabled(viewModel.isButtonDisable)
      Spacer()
    }
  }
  
  func sendMessageAction() {
    viewModel.send(textfieldText, StorageManager.restoreUser().modelSelect)
    textfieldText = ""
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  func setButtonAction() {
    viewModel.setButtonAction(sendMessageAction)
  }
}

struct InputView_Previews: PreviewProvider {
  static var previews: some View {
    InputView(viewModel: InputViewModel(send: {_,_ in }, isShowLoading: false, placeholder: "Input your message", buttonImage: "paperplane.circle.fill", isTextFieldDisable: false, setButtonAction: { _ in }, isButtonDisable: false))
  }
}
