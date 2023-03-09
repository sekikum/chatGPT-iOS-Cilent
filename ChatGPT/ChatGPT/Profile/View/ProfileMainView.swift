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
  
  var body: some View {
    List {
      Section {
        ProfileHeaderView(avatar: homeViewModel.user.avatar, nickname: homeViewModel.user.nickname)
      }
      
      Section {
        ForEach(homeViewModel.user.tokenList, id: \.self) { token in
          Text(token)
            .lineLimit(1)
        }
      }
    }
  }
}

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
      ProfileMainView()
    }
}
