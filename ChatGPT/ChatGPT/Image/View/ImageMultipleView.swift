//
//  ImageMultipleView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/24.
//

import SwiftUI

struct ImageMultipleView: View {
  @Binding var select: Int
  @Binding var isShowBrowser: Bool
  @Binding var imagesURL: [String]
  @Binding var images: [Image]
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
            .onAppear {
              images[imagesURL.firstIndex(of: url)!] = image
            }
        } placeholder: {
          ProgressView("Loading")
        }
        .onTapGesture {
          select = imagesURL.firstIndex(of: url)!
          isShowBrowser = true
          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
      }
    }
    .padding(.trailing, padding)
    .padding(.leading, padding)
  }
}

struct ImageMultipleView_Previews: PreviewProvider {
  static var previews: some View {
    ImageMultipleView(select: .constant(1), isShowBrowser: .constant(true), imagesURL: .constant([]), images: .constant([]))
  }
}
