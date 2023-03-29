//
//  ImageView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/24.
//

import SwiftUI

struct ImageView: View {
  @Binding var isShowBrowser: Bool
  @Binding var selectImage: Int
  @Binding var urlImages: [String]
  @Binding var images: [Image]
  let scrollViewPadding: CGFloat = 20
  let singleImagePadding: CGFloat = 30
  let imageSingleSize: CGFloat = UIScreen.main.bounds.size.width - 60
  let cornerRadius: CGFloat = 10
  let shadowRadius: CGFloat = 5
  
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
              .onAppear {
                images.append(image)
              }
          } placeholder: {
            ProgressView("Loading")
          }
          .onTapGesture {
            isShowBrowser = true
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
          }
        } else if urlImages.count <= 6 {
          ImageMultipleView(select: $selectImage, isShowBrowser: $isShowBrowser, imagesURL: $urlImages, images: $images)
        }
        Spacer()
      }
    } else {
      ScrollView {
        ImageMultipleView(select: $selectImage, isShowBrowser: $isShowBrowser, imagesURL: $urlImages, images: $images)
      }
      .padding(.top, scrollViewPadding)
    }
  }
}

struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    ImageView(isShowBrowser: .constant(false), selectImage: .constant(1), urlImages: .constant([]), images: .constant([]))
  }
}
