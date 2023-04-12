//
//  SideMenuView.swift
//  ChatGPT
//
//  Created by cai dongyu on 2023/3/29.
//

import SwiftUI

struct SideMenuView: View {
  @StateObject var viewModel: MessageViewModel
  @Binding var selectedSideMenuTab: Int
  @Binding var presentSideMenu: Bool
  let spacing: CGFloat = 20
  let buttonWidth: CGFloat = 200
  let cornerRadius: CGFloat = 12
  let lineWidth: CGFloat = 1
  let padding: CGFloat = 100
  let frame: CGFloat = 270
  let groupSpacing: CGFloat = 20
  let gruopPadding: CGFloat = 5
  
  var body: some View {
    HStack {
      ZStack{
        VStack(alignment: .center, spacing: spacing) {
          Button {
          //  viewModel.clearContext()
            viewModel.clearScreen()
            viewModel.addGroups()
          } label: {
            HStack {
              Image(systemName: "plus")
              Text("New chat")
            }
            .padding(.horizontal)
            .frame(width: buttonWidth)
            .padding()
            .overlay {
              RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: lineWidth)
            }
          }
          groupListView()
          Spacer()
        }
        .padding(.top, padding)
        .frame(width: frame)
        .background(
          Color("Gray")
        )
      }
      Spacer()
    }
    .background(.clear)
    .onAppear {
    //  viewModel.fetchGroups()
      
    }
  }
  
  func groupListView() -> some View {
    List {
      ForEach(viewModel.chatGroups, id: \.timestamp) { group in
        HStack(spacing: groupSpacing) {
          Image(systemName: "bubble.left.fill")

          if let flag = group.flag {
            Text(flag)
              .font(.system(.title2))
          }
        }
        .listRowBackground(Color.clear)
        .onTapGesture(perform: {
          viewModel.setCurrentChat(group)
          presentSideMenu.toggle()
        })
        .padding(gruopPadding)
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

