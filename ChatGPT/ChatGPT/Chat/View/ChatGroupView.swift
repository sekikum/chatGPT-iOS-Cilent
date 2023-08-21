//
//  ChatGroupView.swift
//  ChatGPT
//
//  Created by cai dongyu on 2023/4/18.
//

import SwiftUI

struct ChatGroupView: View {
  @Environment(\.scenePhase) var scenePhase
  @EnvironmentObject var quickActionSettings: QuickActionSettings
  @StateObject var viewModel: ChatGroupViewModel = ChatGroupViewModel()
  @State private var navigateToNewGroup = false
  let avatar: String
  let listPadding: CGFloat = 8
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.chatGroups, id: \.self) { chatGroup in
          if let title = chatGroup.title {
            NavigationLink {
              ChatMainView(viewModel: ChatMainViewModel(chatGroup: chatGroup, dataRepository: viewModel.dataRepository), avatar: avatar)
            } label: {
              Label(title, systemImage: "bubble.left")
            }
            .padding(.vertical, listPadding)
          }
        }
        .onDelete { indexSet in
          for index in indexSet {
            viewModel.deleteChatGroup(index)
          }
        }
      }
      .navigationTitle("Chat")
      .navigationBarTitleDisplayMode(.inline)
      .navigationDestination(isPresented: $navigateToNewGroup) {
        ChatMainView(viewModel: ChatMainViewModel(chatGroup: viewModel.chatGroups.last!, dataRepository: viewModel.dataRepository), avatar: avatar)
      }
      .onAppear {
        viewModel.setChatGroups()
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            addNewChat()
          }) {
            Image(systemName: "plus")
              .resizable()
          }
        }
      }
      .onChange(of: scenePhase) { newScene in
        switch newScene {
        case .active:
          performActionIfNeeded()
        default:
          break
        }
      }
    }
  }
  
  func addNewChat() {
    navigateToNewGroup = true
    viewModel.addChatGroup()
  }
  
  func performActionIfNeeded() {
    guard let action = quickActionSettings.quickAction else { return }
    
    switch action {
    case .newChat:
      addNewChat()
    }
    quickActionSettings.quickAction = nil
  }
}

struct ChatGroupView_Previews: PreviewProvider {
  static var previews: some View {
    ChatGroupView(viewModel: ChatGroupViewModel(), avatar: "Profile-User")
  }
}
