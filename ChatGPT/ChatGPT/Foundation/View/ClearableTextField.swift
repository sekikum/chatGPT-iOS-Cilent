//
//  ClearableTextField.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/4/21.
//

import SwiftUI

struct ClearableTextField: View {
  @Binding var text: String
  
  var placeholder: String = ""
  var onCommit: () -> Void = {}
  let textFieldTrailingPadding: CGFloat = 35
  
  init(_ placeholder: String, text: Binding<String>, onCommit: @escaping () -> Void = {}) {
    self.placeholder = placeholder
    self._text = text
    self.onCommit = onCommit
  }
  
  var body: some View {
    ZStack(alignment: .trailing) {
      TextField(placeholder, text: $text, onCommit: onCommit)
        .textFieldStyle(PlainTextFieldStyle())
        .autocapitalization(.none)
        .padding(.trailing, textFieldTrailingPadding)
      
      if !text.isEmpty {
        Button(action: {
          self.text = ""
        }) {
          Image(systemName: "xmark.circle.fill")
            .foregroundColor(.secondary)
        }
      }
    }
  }
  
  func keyboardType(_ type: UIKeyboardType) -> some View {
    return self.modifier(KeyboardModifier(keyboardType: type))
  }
  
  func submitLabel(_ label: String) -> some View {
    return self.modifier(SubmitLabelModifier(submitLabel: label))
  }
  
  struct KeyboardModifier: ViewModifier {
    let keyboardType: UIKeyboardType
    
    func body(content: Content) -> some View {
      content
        .keyboardType(keyboardType)
    }
  }
  
  struct SubmitLabelModifier: ViewModifier {
    let submitLabel: String
    
    func body(content: Content) -> some View {
      content
        .textFieldStyle(PlainTextFieldStyle())
        .background(
          submitLabel.isEmpty ? AnyView(EmptyView()) : AnyView(
            HStack {
              Spacer()
              Button(action: {}) {
                Text(submitLabel)
                  .font(.body)
                  .foregroundColor(.blue)
              }
            }
          )
        )
    }
  }
}

struct ClearableTextField_Previews: PreviewProvider {
  static var previews: some View {
    ClearableTextField("Input your name", text: .constant(""))
  }
}

