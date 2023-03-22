//
//  ProfileMainView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import SwiftUI

struct ProfileMainView: View {
  @StateObject var viewModel: UserViewModel
  @State var tokenText: String = ""
  @State var baseURLText: String = ""
  @State var isShowTokenEmptyAlert: Bool = false
  @State var isShowBaseURLEmptyAlert: Bool = false
  @State var isShowDeleteAlert: Bool = false
  @State var deletedToken: String = ""
  let profileViewModel: ProfileViewModel = ProfileViewModel()
  let models: [String] = ["gpt-3.5", "gpt-3.5-0310"]
  let initToken: (String) -> Void
  let tokenLineLimit: Int = 1
  
  var body: some View {
    List {
      Section {
        ProfileHeaderView(avatar: viewModel.user.avatar, nickname: viewModel.user.nickname)
      }
      
      Section {
        Picker("chose gpt model", selection: $viewModel.user.modelSelect) {
          ForEach(models, id: \.self) { model in
            Text(model)
          }
        }
        .onChange(of: viewModel.user.modelSelect) { _ in
          Task {
            await StorageManager.storeUser(viewModel.user)
          }
        }
      }
      
      Section {
        HStack {
          TextField(viewModel.user.baseURL.isEmpty ?  "input your baseURL" : viewModel.user.baseURL, text: $baseURLText)
            .disableAutocorrection(true)
            .autocapitalization(.none)
          Button("Done", action: addBaseURL)
          .buttonStyle(.borderedProminent)
          .alert("baseURL cannot be empty", isPresented: $isShowBaseURLEmptyAlert) {
            Button("OK", role: .cancel) { }
          }
          Button("Clear", action: viewModel.clearBaseURL)
            .buttonStyle(.borderedProminent)
        }
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
          TextField("input new token", text: $tokenText)
            .keyboardType(.default)
            .submitLabel(.done)
            .onSubmit(addNewToken)
            .disableAutocorrection(true)
            .autocapitalization(.none)
          Button("add", action: addNewToken)
            .buttonStyle(.borderedProminent)
            .alert("token cannot be empty", isPresented: $isShowTokenEmptyAlert) {
              Button("OK", role: .cancel) { }
            }
        }
      }
    }
    .scrollDismissesKeyboard(.immediately)
  }
}

extension ProfileMainView {
  func addNewToken() {
    if profileViewModel.isWhitespaceString(tokenText) {
      isShowTokenEmptyAlert = true
      return
    }
    viewModel.addToken(tokenText)
    tokenText = ""
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  func deleteToken() {
    viewModel.deleteToken(deletedToken)
    deletedToken = ""
  }
  
  func addBaseURL() {
    if profileViewModel.isWhitespaceString(baseURLText) {
      isShowBaseURLEmptyAlert = true
      return
    }
    viewModel.addBaseURL(baseURLText)
    baseURLText = ""
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

struct ProfileMainView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileMainView(viewModel: UserViewModel(), initToken: {_ in})
  }
}
