//
//  ProfileMainView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import Foundation
import SwiftUI

struct ProfileMainView: View {
  @EnvironmentObject var homeViewModel: HomeViewModel
  @State var selection: String = ""
  @State var textfieldText: String = ""
  @State var isShowAlert: Bool = false
  let tokenLineLimit: Int = 1
  
  var body: some View {
    List {
      Section {
        ProfileHeaderView(avatar: homeViewModel.user.avatar, nickname: homeViewModel.user.nickname)
      }
      
      Section {
        if homeViewModel.user.tokenList.isEmpty {
          Text("No token added")
        } else {
          Picker(selection: $selection, label: Text("Choose a token")) {
            ForEach(homeViewModel.user.tokenList, id: \.self) { token in
              Text(token)
                .lineLimit(tokenLineLimit)
            }
          }
          .pickerStyle(.inline)
        }
      }
      
      Section {
        HStack {
          TextField("input new token", text: $textfieldText)
            .keyboardType(.default)
            .submitLabel(.done)
            .onSubmit(addNewToken)
          Button("add", action: addNewToken)
            .buttonStyle(.borderedProminent)
            .alert("token cannot be empty", isPresented: $isShowAlert) {
              Button("OK", role: .cancel) { }
            }
        }
      }
    }
  }
  
  func addNewToken() {
    if textfieldText.isEmpty {
      isShowAlert = true
      return
    }
    homeViewModel.user.tokenList.append(textfieldText)
    textfieldText = ""
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

struct ProfileMainView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileMainView()
  }
}
