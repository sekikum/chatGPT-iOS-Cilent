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
  @State var baseURLText: String = StorageManager.restoreUser().baseURL
  @State var isShowTokenEmptyAlert: Bool = false
  @State var isShowBaseURLAlert: Bool = false
  @State var isShowDeleteAlert: Bool = false
  @State var deletedToken: String = ""
  @State var urlAlertText: String = ""
  @State var isToggleOn: Bool = false
  let profileViewModel: ProfileViewModel = ProfileViewModel()
  let models: [String] = ["gpt-3.5", "gpt-3.5-0310"]
  let initTokenMessage: (String) -> Void
  let initTokenImage: (String) -> Void
  let tokenLineLimit: Int = 1
  let toggleWidth: CGFloat = 50
  let buttonSize: CGFloat = 30
  
  var body: some View {
    List {
      Section {
        ProfileHeaderView(avatar: viewModel.user.avatar, nickname: viewModel.user.nickname)
      }
      
      Section {
        Picker("Chose GPT model", selection: $viewModel.user.modelSelect) {
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
          TextField("Input your BaseURL", text: $baseURLText)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .onTapGesture {
              isToggleOn = false
            }
          Toggle("", isOn: $isToggleOn)
            .onChange(of: isToggleOn) { isOn in
              if isOn {
                addBaseURL()
              } else {
                clearBaseURL()
              }
            }
            .alert(urlAlertText, isPresented: $isShowBaseURLAlert) {
              Button("OK", role: .cancel) { }
            }
            .frame(width: toggleWidth)
        }
      }
      
      Section(viewModel.user.tokenList.isEmpty ? "No APIKey added" : "Choose a APIKey\n(Long press APIKey to delete)") {
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
            title: Text("Do you sure you want to delete this APIKey?"),
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
            initTokenMessage(viewModel.user.tokenSelect)
            initTokenImage(viewModel.user.tokenSelect)
          }
        }
      }
      
      Section {
        HStack {
          TextField("Input new APIKey", text: $tokenText)
            .keyboardType(.default)
            .submitLabel(.done)
            .onSubmit(addNewToken)
            .disableAutocorrection(true)
            .autocapitalization(.none)
          Button(action: addNewToken) {
            Image(systemName: "plus.circle.fill")
              .resizable()
              .frame(width: buttonSize, height: buttonSize)
          }
          .alert("APIKey cannot be empty", isPresented: $isShowTokenEmptyAlert) {
            Button("OK", role: .cancel) { }
          }
        }
      }
    }
  }
}

extension ProfileMainView {
  func addNewToken() {
    if profileViewModel.trimString(tokenText).isEmpty {
      isShowTokenEmptyAlert = true
      tokenText = ""
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
    let url = profileViewModel.trimString(baseURLText)
    baseURLText = url
    if url.isEmpty {
      isToggleOn = false
    } else if !profileViewModel.isValidURL(url) {
      isShowBaseURLAlert = true
      isToggleOn = false
      urlAlertText = NSLocalizedString("BaseURL illegal", comment: "")
      baseURLText = ""
    } else {
      viewModel.addBaseURL(baseURLText)
    }
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  func clearBaseURL() {
    viewModel.addBaseURL("")
  }
}

struct ProfileMainView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileMainView(viewModel: UserViewModel(), initTokenMessage: {_ in}, initTokenImage: {_ in})
  }
}
