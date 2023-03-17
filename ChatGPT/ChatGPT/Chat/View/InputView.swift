//
//  InputView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import SwiftUI

struct InputView: View {
  @State var textfieldText: String = ""
  @Binding var isShowAlert: Bool
  let noTokenAdded: Bool
  let alertInfo: String
  let send: (String) -> Void
  let clear: () -> Void
  let padding: CGFloat = 6
  let cornerRadius: CGFloat = 6
  let textFieldLimit = 4
  
  var body: some View {
    HStack {
      TextField(noTokenAdded ? "Please add token on 'me'" : "", text: $textfieldText, axis: .vertical)
        .disabled(noTokenAdded)
        .lineLimit(textFieldLimit)
        .padding(padding)
        .background(Color("Gray"))
        .cornerRadius(cornerRadius)
        .keyboardType(.default)
        .submitLabel(.done)
        .onSubmit(sendMessageAction)
      Button("send", action: sendMessageAction)
        .buttonStyle(.borderedProminent)
        .alert(alertInfo, isPresented: $isShowAlert) {
          Button("OK", role: .cancel) { }
        }
      Button("clear", action: clear)
        .buttonStyle(.borderedProminent)
    }
  }
  
  func sendMessageAction() {
    send(textfieldText)
    textfieldText = ""
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

struct InputView_Previews: PreviewProvider {
  static var previews: some View {
    InputView(isShowAlert: .constant(false), noTokenAdded: false, alertInfo: "", send: {_ in }, clear: { })
  }
}
