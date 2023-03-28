//
//  ImageMultipleView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/24.
//

import SwiftUI

struct ImageMultipleView: View {
  let imagesURL: [String]
  let imageSize = (UIScreen.main.bounds.size.width - 45) / 2
  let cornerRadius: CGFloat = 10
  let shadowRadius: CGFloat = 5
  let spacing: CGFloat = 15
  let padding: CGFloat = 10
  
  var body: some View {
    LazyVGrid(columns: [GridItem(), GridItem()], spacing: spacing) {
      ForEach(imagesURL, id: \.self) { url in
        AsyncImage(url: URL(string: url)) { image in
          image
            .resizable()
            .scaledToFit()
            .frame(width: imageSize, height: imageSize)
            .cornerRadius(cornerRadius)
            .shadow(radius: shadowRadius)
        } placeholder: {
          ProgressView("Loading")
        }
      }
    }
    .padding(.trailing, padding)
    .padding(.leading, padding)
  }
}

struct ImageMultipleView_Previews: PreviewProvider {
  static var previews: some View {
    ImageMultipleView(imagesURL: ["lasso", "trash", "trash.fill", "cloud.fill", "folder", "folder.fill"])
  }
}
