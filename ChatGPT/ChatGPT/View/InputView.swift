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
  
  var body: some View {
    HStack {
      TextField("", text: $textfieldText)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      Button("send") {
        print(textfieldText)
      }
    }
    .padding()
  }
}

struct InputView_Previews: PreviewProvider {
  static var previews: some View {
    InputView()
  }
}
