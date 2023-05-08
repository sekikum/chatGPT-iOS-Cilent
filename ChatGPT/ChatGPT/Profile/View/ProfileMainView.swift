//
//  ProfileMainView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import SwiftUI

struct ProfileMainView: View {
  @StateObject var viewModel: ProfileViewModel
  @State var apiKeyText: String = ""
  @State var baseURLText: String = StorageManager.restoreUser().baseURL
  @State var isShowAPIKeyEmptyAlert: Bool = false
  @State var isShowBaseURLAlert: Bool = false
  @State var isShowDeleteAlert: Bool = false
  @State var deletedAPIKey: String = ""
  @State var urlAlertText: String = ""
  @State var isToggleOn: Bool = false
  let models: [String] = ["gpt-3.5", "gpt-3.5-0310", "gpt-4"]
  let apiKeyLineLimit: Int = 1
  let toggleWidth: CGFloat = 50
  let buttonSize: CGFloat = 30
  let listTopPadding: CGFloat = 1
  
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
      
      Section {
        HStack {
          ClearableTextField("Input new APIKey", text: $apiKeyText)
            .keyboardType(.default)
            .submitLabel(.done)
            .onSubmit(addNewAPIKey)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .alert("APIKey cannot be empty", isPresented: $isShowAPIKeyEmptyAlert) {
              Button("OK", role: .cancel) { }
            }
        }
      }
      
      Section(viewModel.user.apiKeyList.isEmpty ? "No APIKey added" : "Choose a APIKey\n(Long press APIKey to delete)") {
        Picker("", selection: $viewModel.user.apiKeySelect) {
          ForEach(viewModel.user.apiKeyList, id: \.self) { apiKey in
            Text(viewModel.maskAPIKey(apiKey))
              .gesture(
                LongPressGesture(minimumDuration: 1)
                  .onEnded { value in
                    isShowDeleteAlert = value
                    deletedAPIKey = apiKey
                  })
              .lineLimit(apiKeyLineLimit)
          }
        }
        .alert(isPresented: $isShowDeleteAlert) { () -> Alert in
          Alert(
            title: Text("Do you sure you want to delete this APIKey?"),
            message: Text("There is no undo"),
            primaryButton: .destructive(Text("Delete")) {
              deleteAPIKey()
            },
            secondaryButton: .cancel())
        }
        .labelsHidden()
        .pickerStyle(.inline)
        .onChange(of: viewModel.user.apiKeySelect) { _ in
          ClientManager.shared.updateOpenAI(viewModel.user.apiKeySelect)
          Task {
            await StorageManager.storeUser(viewModel.user)
          }
        }
      }
    }
    .padding(.top, listTopPadding)
    .gesture(DragGesture().onChanged{ _ in
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    })
  }
}

extension ProfileMainView {
  func addNewAPIKey() {
    if viewModel.trimString(apiKeyText).isEmpty {
      isShowAPIKeyEmptyAlert = true
      apiKeyText = ""
      return
    }
    viewModel.addAPIKey(apiKeyText)
    apiKeyText = ""
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  func deleteAPIKey() {
    viewModel.deleteAPIKey(deletedAPIKey)
    deletedAPIKey = ""
  }
  
  func addBaseURL() {
    let url = viewModel.trimString(baseURLText)
    baseURLText = url
    if url.isEmpty {
      isToggleOn = false
    } else if !viewModel.isValidURL(url) {
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
    ProfileMainView(viewModel: ProfileViewModel())
  }
}
