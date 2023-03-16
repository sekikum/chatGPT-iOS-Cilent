//
//  ProfileMainView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import Foundation
import SwiftUI

struct ProfileMainView: View {
  @StateObject var viewModel: UserViewModel
  @State var textfieldText: String = ""
  @State var isShowAlert: Bool = false
  let profileViewModel: ProfileViewModel = ProfileViewModel()
  let initToken: (String) -> Void
  let tokenLineLimit: Int = 1
  
  var body: some View {
    List {
      Section {
        ProfileHeaderView(avatar: viewModel.user.avatar, nickname: viewModel.user.nickname)
      }
      
      Section {
        if viewModel.user.tokenList.isEmpty {
          Text("No token added")
        } else {
          Picker(selection: $viewModel.user.tokenSelect, label: Text("Choose a token").foregroundColor(.blue)) {
            ForEach(viewModel.user.tokenList, id: \.self) { token in
              Text(profileViewModel.maskToken(token))
                .lineLimit(tokenLineLimit)
            }
          }
          .pickerStyle(.inline)
          .onChange(of: viewModel.user.tokenSelect) { _ in
            Task {
              await StorageManager.storeUser(viewModel.user)
              initToken(viewModel.user.tokenSelect)
            }
          }
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
    viewModel.addToken(textfieldText)
    textfieldText = ""
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

struct ProfileMainView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileMainView(viewModel: UserViewModel(), initToken: {_ in})
  }
}
