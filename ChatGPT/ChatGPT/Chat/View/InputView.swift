//
//  InputView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import SwiftUI

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
      TextField(viewModel.makePlaceholder(), text: $textfieldText, axis: .vertical)
        .disabled(viewModel.getTextFieldDisable())
        .lineLimit(textFieldLimit)
        .padding(padding)
        .background(Color("Gray"))
        .cornerRadius(cornerRadius)
        .keyboardType(.default)
        .disableAutocorrection(true)
        .autocapitalization(.none)
      Button(action: setButtonAction) {
        Image(systemName: viewModel.makeButtonImage())
          .resizable()
          .frame(width: buttonSize, height: buttonSize)
      }
      .overlay() {
        if viewModel.isShowLoading {
          ProgressView()
        }
      }
      .disabled(viewModel.isButtonDisable())
      Spacer()
    }
  }
  
  func sendMessageAction() {
    viewModel.send(textfieldText, StorageManager.restoreUser().modelSelect)
    textfieldText = ""
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  func setButtonAction() {
    viewModel.updateButtonAction(send: sendMessageAction)
  }
}

struct InputView_Previews: PreviewProvider {
  static var previews: some View {
    InputView(viewModel: InputViewModel(isStreaming: false, isShowLoading: false, send: {_,_ in }, cancel: {}))
  }
}
