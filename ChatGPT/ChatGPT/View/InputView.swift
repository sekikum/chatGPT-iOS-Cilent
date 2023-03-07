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
  let padding: CGFloat = 6
  let cornerRadius: CGFloat = 6
  
  var body: some View {
    HStack {
      TextField("", text: $textfieldText)
        .padding(padding)
        .background(Color("Gray"))
        .cornerRadius(cornerRadius)
        .keyboardType(.default)
      Button("send") {
        print(textfieldText)
      }
      .buttonStyle(.borderedProminent)
    }
  }
}

struct InputView_Previews: PreviewProvider {
  static var previews: some View {
    InputView()
  }
}
