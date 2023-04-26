//
//  ContentView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/3.
//

import SwiftUI

struct HomeView: View {
  @StateObject var userViewModel: UserViewModel = UserViewModel()
  @StateObject var chatMainViewModel: ChatMainViewModel = ChatMainViewModel()
  @StateObject var imageChatMainViewModel: ImageChatMainViewModel = ImageChatMainViewModel()
  @State var selectionTab: HomeTab = .chat
  @State var isShowBrowser = false
  @State var selectImage: Int = .init()
  
  @State var images: [Image] = .init(repeating: Image(systemName: "arrow.clockwise"), count: StorageManager.restoreImageSet().number)
  let numberList: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  let sizeList: [String] = ["256x256", "512x512", "1024x1024"]
  let frameWidth: CGFloat = 20
  let frameHeight: CGFloat = 20
  let imagePadding: CGFloat = 20
  let buttonPadding: CGFloat = 24
  
  var body: some View {
    ZStack {
      TabView(selection: $selectionTab) {
        ChatGroupView(viewModel: chatMainViewModel, avatar: userViewModel.user.avatar)
          .tabItem {
            Label("Chat", systemImage: "message.fill")
          }
          .tag(HomeTab.chat)
        
        NavigationView {
          ImageChatMainView(viewModel: imageChatMainViewModel, isShowBrowser: $isShowBrowser, selectImage: $selectImage, images: $images, avatar: userViewModel.user.avatar)
            .navigationBarItems(trailing: Menu {
              Picker("Number: \(String(imageChatMainViewModel.imageSet.number))", selection: $imageChatMainViewModel.imageSet.number) {
                ForEach(numberList, id: \.self) { num in
                  Text("\(num)")
                }
              }
              .pickerStyle(.menu)
              .onChange(of: imageChatMainViewModel.imageSet.number) { _ in
                Task {
                  images = .init(repeating: Image(systemName: "arrow.clockwise"), count: imageChatMainViewModel.imageSet.number)
                  await StorageManager.storeImageSet(imageChatMainViewModel.imageSet)
                }
              }
              Picker("Size: \(imageChatMainViewModel.imageSet.size)", selection: $imageChatMainViewModel.imageSet.size) {
                ForEach(sizeList, id: \.self) { str in
                  Text("\(str)")
                }
              }
              .pickerStyle(.menu)
              .onChange(of: imageChatMainViewModel.imageSet.size) { _ in
                Task {
                  await StorageManager.storeImageSet(imageChatMainViewModel.imageSet)
                }
              }
            } label: {
              Image(systemName: "ellipsis")
            })
        }
        .tabItem {
          Label("Image", systemImage: "photo.circle.fill")
        }
        .tag(HomeTab.image)
        
        ProfileMainView(viewModel: userViewModel, initAPIKeyMessage: chatMainViewModel.initOpenAI, initAPIKeyImage: imageChatMainViewModel.initOpenAI)
          .tabItem {
            Label("Me", systemImage: "person.fill")
          }
          .tag(HomeTab.me)
      }
    }
    .overlay {
      ImageBrowserView(isShow: $isShowBrowser, selectionTab: $selectImage, images: $images)
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
