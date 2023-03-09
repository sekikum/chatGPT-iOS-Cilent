//
//  ProfileMainView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import Foundation
import SwiftUI

struct ProfileMainView: View {
  @EnvironmentObject var homeViewModel: HomeViewModel
  @State var selection: String = ""
  
  var body: some View {
    List {
      Section {
        ProfileHeaderView(avatar: homeViewModel.user.avatar, nickname: homeViewModel.user.nickname)
      }
      
      Section {
        if homeViewModel.user.tokenList.isEmpty {
          Text("No token added")
        } else {
          Picker(selection: $selection, label: Text("")) {
            ForEach(homeViewModel.user.tokenList, id: \.self) { token in
              Text(token)
            }
          }
          .labelsHidden()
        }
      }
    }
  }
  
  func setSelectedToken() {
    homeViewModel.user.tokenSelect = selection
  }
}

struct ProfileMainView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileMainView()
  }
}
