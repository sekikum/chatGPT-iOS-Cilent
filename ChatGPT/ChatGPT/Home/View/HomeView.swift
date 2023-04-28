//
//  ContentView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/3.
//

import SwiftUI

struct HomeView: View {
  @State var selectionTab: HomeTab = .chat
  @State var isShowBrowser = false
  @State var selectImage: Int = .init()
  @State var images: [Image] = .init(repeating: Image(systemName: "arrow.clockwise"), count: StorageManager.restoreImageSet().number)
  let frameWidth: CGFloat = 20
  let frameHeight: CGFloat = 20
  let imagePadding: CGFloat = 20
  let buttonPadding: CGFloat = 24
  
  var body: some View {
    ZStack {
      TabView(selection: $selectionTab) {
        ChatGroupView(avatar: StorageManager.restoreUser().avatar)
          .tabItem {
            Label("Chat", systemImage: "message.fill")
          }
          .tag(HomeTab.chat)
        
        NavigationView {
          ImageChatMainView(isShowBrowser: $isShowBrowser, selectImage: $selectImage, images: $images, avatar: StorageManager.restoreUser().avatar)
        }
        .tabItem {
          Label("Image", systemImage: "photo.circle.fill")
        }
        .tag(HomeTab.image)
        
        ProfileMainView(viewModel: ProfileViewModel())
          .tabItem {
            Label("Me", systemImage: "person.fill")
          }
          .tag(HomeTab.me)
      }
      .overlay {
        ImageBrowserView(isShow: $isShowBrowser, selectionTab: $selectImage, images: $images)
      }
    }
  }
}

enum HomeTab {
  case chat
  case me
  case image
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
