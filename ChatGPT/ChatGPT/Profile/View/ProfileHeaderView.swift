//
//  ProfileHeaderView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import SwiftUI

struct ProfileHeaderView: View {
  let avatar: String
  let nickname: String
  let avatarSize: CGFloat = 70
  let padding: CGFloat = 15
  let fontSize: CGFloat = 20
  let conrnerRadius: CGFloat = 5
  let nickNameLineLimit: Int = 1
  
  var body: some View {
    HStack {
      Image(avatar)
        .resizable()
        .scaledToFit()
        .cornerRadius(conrnerRadius)
        .frame(width: avatarSize, height: avatarSize)
        .padding(.trailing, padding)
        .padding(.leading, padding)
      Text(nickname)
        .font(.system(size: fontSize))
        .lineLimit(nickNameLineLimit)
    }
  }
}

struct ProfileHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileHeaderView(avatar: "Profile-Diu", nickname: "sekikum")
  }
}
