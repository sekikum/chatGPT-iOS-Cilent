//
//  ProfileMainView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import SwiftUI

struct ProfileMainView: View {
  @StateObject var viewModel: UserViewModel
  @State var textfieldText: String = ""
  @State var isShowEmptyAlert: Bool = false
  @State var isShowDeleteAlert: Bool = false
  @State var deletedToken: String = ""
  let profileViewModel: ProfileViewModel = ProfileViewModel()
  let initToken: (String) -> Void
  let tokenLineLimit: Int = 1
  
  var body: some View {
    List {
      Section {
        ProfileHeaderView(avatar: viewModel.user.avatar, nickname: viewModel.user.nickname)
      }
      
      Section(viewModel.user.tokenList.isEmpty ? "No token added" : "Choose a token\n(Long press token to delete)") {
        Picker("", selection: $viewModel.user.tokenSelect) {
          ForEach(viewModel.user.tokenList, id: \.self) { token in
            Text(profileViewModel.maskToken(token))
              .gesture(
                LongPressGesture(minimumDuration: 1)
                  .onEnded { value in
                    isShowDeleteAlert = value
                    deletedToken = token
                  })
              .lineLimit(tokenLineLimit)
          }
        }
        .alert(isPresented: $isShowDeleteAlert) { () -> Alert in
          Alert(
            title: Text("Do you sure you want to delete this Token?"),
            message: Text("There is no undo"),
            primaryButton: .destructive(Text("Delete")) {
              deleteToken()
            },
            secondaryButton: .cancel())
        }
        .labelsHidden()
        .pickerStyle(.inline)
        .onChange(of: viewModel.user.tokenSelect) { _ in
          Task {
            await StorageManager.storeUser(viewModel.user)
            initToken(viewModel.user.tokenSelect)
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
            .alert("token cannot be empty", isPresented: $isShowEmptyAlert) {
              Button("OK", role: .cancel) { }
            }
        }
      }
    }
    .scrollDismissesKeyboard(.immediately)
  }
  
  func addNewToken() {
    if textfieldText.isEmpty {
      isShowEmptyAlert = true
      return
    }
    viewModel.addToken(textfieldText)
    textfieldText = ""
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  func deleteToken() {
    viewModel.deleteToken(deletedToken)
    deletedToken = ""
  }
}

struct ProfileMainView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileMainView(viewModel: UserViewModel(), initToken: {_ in})
  }
}
