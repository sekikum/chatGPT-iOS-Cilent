//
//  SideMenuView.swift
//  ChatGPT
//
//  Created by cai dongyu on 2023/3/29.
//

import SwiftUI

struct SideMenuView: View {
  @ObservedObject var viewModel: MessageViewModel
  @Binding var selectedSideMenuTab: Int
  @Binding var presentSideMenu: Bool
  
  var body: some View {
    HStack {
      ZStack{
        VStack(alignment: .center, spacing: 20) {
          Button {
            viewModel.clearContext()
            viewModel.addGroups()
          } label: {
            HStack {
              Image(systemName: "plus")
              Text("New chat")
            }
            .padding(.horizontal)
            .frame(width: 200)
            .foregroundColor(.white)
            .padding()
            .overlay {
              RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 1)
                .foregroundColor(.white)
            }
          }
          groupListView()
          Spacer()
        }
        .padding(.top, 100)
        .frame(width: 270)
        .background(
          Color.black
        )
      }
      Spacer()
    }
    .background(.clear)
  }
  
  func groupListView() -> some View {
    List {
      ForEach(viewModel.chatGroups) { group in
        HStack(spacing: 20) {
          Image(systemName: "bubble.left.fill")
          Text(group.title)
            .font(.system(.title))
        }
        .listRowBackground(Color.clear)
        .onTapGesture(perform: {
          viewModel.setCurrentChat(group)
          presentSideMenu.toggle()
        })
        .foregroundColor(.white)
        .padding(5)
      }
      .listRowBackground(Color.black)
      
      if viewModel.chatGroups.isEmpty {
        Text("ListFix")
          .hidden()
          .accessibility(hidden: true)
          .listRowBackground(Color.clear)
      }
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
  }
}

struct SideMenuView_Previews: PreviewProvider {
  static let viewModel = MessageViewModel()
  static var previews: some View {
    SideMenuView(viewModel: MessageViewModel(), selectedSideMenuTab: .constant(0), presentSideMenu: .constant(true))
  }
}

