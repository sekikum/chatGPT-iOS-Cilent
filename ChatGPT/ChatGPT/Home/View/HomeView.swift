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
  @State var selectionTab: HomeTab = .chat
  @State var number: Int = 1
  @State var size: String = "256x256"
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
        ImageChatMainView(avatar: userViewModel.user.avatar)
          .navigationBarItems(trailing: Menu {
            Picker("Number: \(number)", selection: $number) {
              ForEach(numberList, id: \.self) { num in
                Text("\(num)")
              }
            }
            .pickerStyle(.menu)
            Picker("Size: \(size)", selection: $size) {
              ForEach(sizeList, id: \.self) { str in
                Text("\(str)")
              }
            }
            .pickerStyle(.menu)
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
