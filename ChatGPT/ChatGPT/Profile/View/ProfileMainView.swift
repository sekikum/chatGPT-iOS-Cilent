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
  
  var body: some View {
    List {
      Section {
        ProfileHeaderView(avatar: homeViewModel.user.avatar, nickname: homeViewModel.user.nickname)
      }
      
      Section {
        if homeViewModel.user.tokenList.isEmpty {
          Text("No token added")
        } else {
          Picker(selection: $selection, label: Text("")) {
            ForEach(homeViewModel.user.tokenList, id: \.self) { token in
              Text(token)
            }
          }
          .labelsHidden()
        }
      }
      
      Section {
        HStack {
          TextField("input new token", text: $textfieldText)
            .keyboardType(.default)
            .submitLabel(.done)
            .onSubmit(addNewToken)
          Button("send", action: addNewToken)
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
