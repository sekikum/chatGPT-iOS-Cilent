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
  let urlImages4: [String] = [
    "https://tw-mobile-xian.github.io/moments-data/images/user/avatar/004.jpeg",
    "https://tw-mobile-xian.github.io/moments-data/images/user/avatar/003.jpeg",
    "https://tw-mobile-xian.github.io/moments-data/images/user/avatar/002.jpeg",
    "https://tw-mobile-xian.github.io/moments-data/images/user/avatar/001.jpeg",
  ]
  let urlImages9: [String] = [
    "https://tw-mobile-xian.github.io/moments-data/images/user/avatar/004.jpeg",
    "https://tw-mobile-xian.github.io/moments-data/images/user/avatar/003.jpeg",
    "https://tw-mobile-xian.github.io/moments-data/images/user/avatar/002.jpeg",
    "https://tw-mobile-xian.github.io/moments-data/images/user/avatar/001.jpeg",
    "https://tw-mobile-xian.github.io/moments-data/images/user/avatar/000.jpeg",
    "https://tw-mobile-xian.github.io/moments-data/images/user/avatar/005.jpeg",
    "https://tw-mobile-xian.github.io/moments-data/images/user/avatar/006.jpeg",
    "https://tw-mobile-xian.github.io/moments-data/images/user/avatar/007.jpeg",
    "https://tw-mobile-xian.github.io/moments-data/images/user/avatar/008.jpeg",
  ]
  
  var body: some View {
    if number <= 6 {
      VStack {
        Spacer()
        if number == 1 {
          AsyncImage(url: URL(string: "https://tw-mobile-xian.github.io/moments-data/images/user/avatar/008.jpeg")) { image in
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
        } else if number <= 6 {
          ImageMultipleView(imagesURL: urlImages4)
        }
        Spacer()
      }
    } else {
      ScrollView {
        ImageMultipleView(imagesURL: urlImages9)
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
