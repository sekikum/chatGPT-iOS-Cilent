//
//  ImageView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/24.
//

import SwiftUI

struct ImageView: View {
  @Binding var isShowBrowser: Bool
  @Binding var selectImage: String
  let scrollViewPadding: CGFloat = 20
  let singleImagePadding: CGFloat = 30
  let imageSingleSize: CGFloat = UIScreen.main.bounds.size.width - 60
  let cornerRadius: CGFloat = 10
  let shadowRadius: CGFloat = 5
  @Binding var urlImages: [String]
  
  var body: some View {
    if urlImages.count <= 6 {
      VStack {
        Spacer()
        if urlImages.count == 1 {
          AsyncImage(url: URL(string: urlImages.first ?? "")) { image in
            image
              .resizable()
              .scaledToFit()
              .frame(width: imageSingleSize, height: imageSingleSize)
              .background(Color.gray)
              .cornerRadius(cornerRadius)
              .shadow(radius: shadowRadius)
              .padding(.leading, singleImagePadding)
              .padding(.trailing, singleImagePadding)
          } placeholder: {
            ProgressView("Loading")
          }
        } else if urlImages.count <= 6 {
          ImageMultipleView(select: $selectImage, isShowBrowser: $isShowBrowser, imagesURL: $urlImages)
        }
        Spacer()
      }
    } else {
      ScrollView {
        ImageMultipleView(select: $selectImage, isShowBrowser: $isShowBrowser, imagesURL: $urlImages)
      }
      .padding(.top, scrollViewPadding)
    }
  }
}

struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    ImageView(isShowBrowser: .constant(false), selectImage: .constant(""), urlImages: .constant([]))
  }
}
