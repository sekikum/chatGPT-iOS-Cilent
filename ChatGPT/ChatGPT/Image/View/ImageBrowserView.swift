//
//  ImageBrowserView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/28.
//

import SwiftUI

struct ImageBrowserView: View {
  @Binding var isShow: Bool
  @Binding var selectionTab: String
  @Binding var images: [String]
  
  var body: some View {
    if isShow {
      TabView(selection: $selectionTab) {
        ForEach(images, id: \.self) { item in
          AsyncImage(url: URL(string: item)) { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: UIScreen.main.bounds.size.width)
          } placeholder: {
            ProgressView("加载中")
          }
          .tag(item)
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
    ImageBrowserView(isShow: .constant(false), selectionTab: .constant(""), images: .constant([]))
  }
}

