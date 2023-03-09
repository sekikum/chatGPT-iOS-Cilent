//
//  InputView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/6.
//

import Foundation
import SwiftUI

struct InputView: View {
  @State var textfieldText: String = ""
  @State var isShowAlert: Bool = false
  let sendCallback: (String) -> Void
  let padding: CGFloat = 6
  let cornerRadius: CGFloat = 6
  
  var body: some View {
    HStack {
      TextField("", text: $textfieldText)
        .padding(padding)
        .background(Color("Gray"))
        .cornerRadius(cornerRadius)
        .keyboardType(.default)
        .submitLabel(.done)
        .onSubmit {
          sendMessageAction()
        }
      Button("send") {
        sendMessageAction()
      }
      .buttonStyle(.borderedProminent)
      .alert("message cannot be empty", isPresented: $isShowAlert) {
        Button("OK", role: .cancel) { }
      }
    }
  }
  
  func sendMessageAction() {
    if textfieldText == "" {
      isShowAlert = true
      return
    }
    sendCallback(textfieldText)
    textfieldText = ""
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

struct InputView_Previews: PreviewProvider {
  static var previews: some View {
    InputView(sendCallback: {_ in })
  }
}
