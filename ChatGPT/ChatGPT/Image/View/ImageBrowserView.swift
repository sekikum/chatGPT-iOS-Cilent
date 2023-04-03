//
//  ImageBrowserView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/28.
//

import SwiftUI

struct ImageBrowserView: View {
  @Binding var isShow: Bool
  @Binding var selectionTab: Int
  @Binding var images: [Image]
  
  var body: some View {
    if isShow {
      TabView(selection: $selectionTab) {
        ForEach(0..<images.count, id: \.self) { imageIndex in
          GeometryReader { proxy in
            images[imageIndex]
              .resizable()
              .frame(width: proxy.size.width, height: proxy.size.width)
              .scaledToFit()
              .modifier(ImageModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.width)))
              .tag(imageIndex)
          }
        }
      }
      .background(.black)
      .tabViewStyle(PageTabViewStyle())
      .onTapGesture {
        isShow = false
      }
    }
  }
}

struct ImageBrowserView_Previews: PreviewProvider {
  static var previews: some View {
    ImageBrowserView(isShow: .constant(false), selectionTab: .constant(1), images: .constant([]))
  }
}
