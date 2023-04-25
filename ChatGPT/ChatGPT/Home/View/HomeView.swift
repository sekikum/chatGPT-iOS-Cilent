//
//  ContentView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/3.
//

import SwiftUI

struct HomeView: View {
  @StateObject var userViewModel: UserViewModel = UserViewModel()
  @StateObject var chatGroupViewModel: ChatGroupViewModel = ChatGroupViewModel()
  @StateObject var imageViewModel: ImageViewModel = ImageViewModel()
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
        ChatGroupView(viewModel: chatGroupViewModel, avatar: userViewModel.user.avatar)
          .tabItem {
            Label("Chat", systemImage: "message.fill")
          }
          .tag(HomeTab.chat)
        
        NavigationView {
          ImageChatMainView(viewModel: imageViewModel, isShowBrowser: $isShowBrowser, selectImage: $selectImage, images: $images, avatar: userViewModel.user.avatar)
            .navigationBarItems(trailing: Menu {
              Picker("Number: \(String(imageViewModel.imageSet.number))", selection: $imageViewModel.imageSet.number) {
                ForEach(numberList, id: \.self) { num in
                  Text("\(num)")
                }
              }
              .pickerStyle(.menu)
              .onChange(of: imageViewModel.imageSet.number) { _ in
                Task {
                  images = .init(repeating: Image(systemName: "arrow.clockwise"), count: imageViewModel.imageSet.number)
                  await StorageManager.storeImageSet(imageViewModel.imageSet)
                }
              }
              Picker("Size: \(imageViewModel.imageSet.size)", selection: $imageViewModel.imageSet.size) {
                ForEach(sizeList, id: \.self) { str in
                  Text("\(str)")
                }
              }
              .pickerStyle(.menu)
              .onChange(of: imageViewModel.imageSet.size) { _ in
                Task {
                  await StorageManager.storeImageSet(imageViewModel.imageSet)
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
        
        ProfileMainView(viewModel: userViewModel, initAPIKeyMessage: chatGroupViewModel.initOpenAI, initAPIKeyImage: imageViewModel.initOpenAI)
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
