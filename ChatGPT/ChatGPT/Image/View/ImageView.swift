//
//  ImageView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/24.
//

import SwiftUI

struct ImageView: View {
  let number: Int
  let scrollViewPadding: CGFloat = 20
  let singleImagePadding: CGFloat = 30
  let imageSingleSize: CGFloat = UIScreen.main.bounds.size.width - 60
  let cornerRadius: CGFloat = 10
  let shadowRadius: CGFloat = 5
  let imageNames10: [String] = ["person", "cloud", "person.fill", "lasso", "trash", "trash.fill", "cloud.fill", "folder", "folder.fill"]
  let imageNames6: [String] = ["lasso", "trash", "trash.fill", "cloud.fill", "folder", "folder.fill"]
  
  var body: some View {
    if number <= 6 {
      VStack {
        Spacer()
        if number == 1 {
          Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: imageSingleSize, height: imageSingleSize)
            .background(Color.gray)
            .cornerRadius(cornerRadius)
            .shadow(radius: shadowRadius)
            .padding(.leading, singleImagePadding)
            .padding(.trailing, singleImagePadding)
        } else if number <= 6 {
          ImageMultipleView(imageNames: imageNames6)
        }
        Spacer()
      }
    } else {
      ScrollView {
        ImageMultipleView(imageNames: imageNames10)
      }
      .padding(.top, scrollViewPadding)
    }
  }
}

struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    ImageView(number: 3)
  }
}
