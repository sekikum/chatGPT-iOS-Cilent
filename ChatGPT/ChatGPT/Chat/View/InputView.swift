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
  let alertInfo: String
  let send: (String, String) -> Void
  let clear: () -> Void
  let isShowLoading: Bool
  let padding: CGFloat = 6
  let cornerRadius: CGFloat = 6
  let textFieldLimit = 4
  let noTokenAdded = StorageManager.restoreUser().tokenList.isEmpty
  let modelSelect = StorageManager.restoreUser().modelSelect
  
  var body: some View {
    HStack {
      TextField(noTokenAdded ? "Please add token on 'me'" : "Input your message", text: $textfieldText, axis: .vertical)
        .disabled(noTokenAdded)
        .lineLimit(textFieldLimit)
        .padding(padding)
        .background(Color("Gray"))
        .cornerRadius(cornerRadius)
        .keyboardType(.default)
        .disableAutocorrection(true)
        .autocapitalization(.none)
      Button("send", action: sendMessageAction)
        .buttonStyle(.borderedProminent)
        .alert(alertInfo, isPresented: $isShowAlert) {
          Button("OK", role: .cancel) { }
        }
        .overlay() {
          if isShowLoading {
            ProgressView()
          }
        }
        .disabled(isShowLoading || noTokenAdded)
      Button("clear", action: clear)
        .buttonStyle(.borderedProminent)
    }
  }
  
  func sendMessageAction() {
    send(textfieldText, modelSelect)
    textfieldText = ""
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

struct InputView_Previews: PreviewProvider {
  static var previews: some View {
    InputView(isShowAlert: .constant(false), alertInfo: "", send: {_,_  in }, clear: { }, isShowLoading: false)
  }
}
