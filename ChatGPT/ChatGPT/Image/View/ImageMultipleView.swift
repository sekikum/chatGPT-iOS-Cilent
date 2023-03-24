//
//  ImageMultipleView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/24.
//

import SwiftUI

struct ImageMultipleView: View {
  let imageNames: [String]
  let imageSize = (UIScreen.main.bounds.size.width - 45) / 2
  let cornerRadius: CGFloat = 10
  let shadowRadius: CGFloat = 5
  let spacing: CGFloat = 15
  let padding: CGFloat = 10
  
  var body: some View {
    LazyVGrid(columns: [GridItem(), GridItem()], spacing: spacing) {
      ForEach(imageNames, id: \.self) { imageName in
        Image(systemName: imageName)
          .resizable()
          .scaledToFit()
          .frame(width: imageSize, height: imageSize)
          .background(Color.gray)
          .cornerRadius(cornerRadius)
          .shadow(radius: shadowRadius)
      }
    }
    .padding(.trailing, padding)
    .padding(.leading, padding)
  }
}

struct ImageMultipleView_Previews: PreviewProvider {
  static var previews: some View {
    ImageMultipleView(imageNames: ["lasso", "trash", "trash.fill", "cloud.fill", "folder", "folder.fill"])
  }
}
