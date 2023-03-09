//
//  ProfileMainView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/9.
//

import Foundation
import SwiftUI

struct ProfileMainView: View {
  var body: some View {
    List {
      Section {
        ProfileHeaderView()
      }
    }
  }
}

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
      ProfileMainView()
    }
}
