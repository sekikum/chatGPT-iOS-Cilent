//
//  ContentView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/3.
//

import SwiftUI

struct HomeView: View {
  @StateObject var userViewModel: UserViewModel = UserViewModel()
  @StateObject var messageViewModel: MessageViewModel = MessageViewModel()
  @StateObject var imageViewModel: ImageViewModel = ImageViewModel()
  @State var selectionTab: HomeTab = .chat
  @State var isShowBrowser = false
  @State var selectImage: String = .init()
  let numberList: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  let sizeList: [String] = ["256x256", "512x512", "1024x1024"]
  
  var body: some View {
    TabView(selection: $selectionTab) {
      NavigationView {
        ChatMainView(viewModel: messageViewModel, avatar: userViewModel.user.avatar)
          .navigationBarItems(trailing: Menu {
            Button(action: messageViewModel.clearContext) {
              Text("Clear")
              Image(systemName: "xmark.circle.fill")
            }
          } label: {
            Image(systemName: "ellipsis")
          })
      }
      .tabItem {
        Label("Chat", systemImage: "message.fill")
      }
      .tag(HomeTab.chat)
      
      NavigationView {
        ImageChatMainView(urlImages: $imageViewModel.imagesURL, isShowBrowser: $isShowBrowser, selectImage: $selectImage, isShowAlert: $imageViewModel.isShowAlert, alertInfo: imageViewModel.alertInfo, avatar: userViewModel.user.avatar, number: imageViewModel.imageSet.number, send: imageViewModel.sendPrompt(_:), isShowLoading: imageViewModel.isShowLoading)
          .navigationBarItems(trailing: Menu {
            Picker("Number: \(String(imageViewModel.imageSet.number))", selection: $imageViewModel.imageSet.number) {
              ForEach(numberList, id: \.self) { num in
                Text("\(num)")
              }
            }
            .pickerStyle(.menu)
            .onChange(of: imageViewModel.imageSet.number) { _ in
              Task {
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
      
      ProfileMainView(viewModel: userViewModel, initToken: messageViewModel.initOpenAI)
        .tabItem {
          Label("Me", systemImage: "person.fill")
        }
        .tag(HomeTab.me)
    }
    .overlay {
      ImageBrowserView(isShow: $isShowBrowser, selectionTab: $selectImage, images: $imageViewModel.imagesURL)
    }
    .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
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
