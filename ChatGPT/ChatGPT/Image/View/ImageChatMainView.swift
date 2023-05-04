//
//  ImageView.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/3/24.
//

import SwiftUI

struct ImageChatMainView: View {
  @StateObject var viewModel: ImageChatMainViewModel = ImageChatMainViewModel()
  @State var textField: String = ""
  @Binding var isShowBrowser: Bool
  @Binding var selectImage: Int
  @Binding var images: [Image]
  let avatar: String
  let numberList: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  let sizeList: [String] = ["256x256", "512x512", "1024x1024"]
  let buttonSize: CGFloat = 30
  let textFieldLimit: Int = 4
  let cornerRadius: CGFloat = 6
  let padding: CGFloat = 6
  
  var body: some View {
    NavigationView {
      VStack {
        Spacer()
        HStack {
          Spacer()
          Image(avatar)
          TextField(viewModel.makePlaceholder(), text: $textField, axis: .vertical)
            .disabled(viewModel.isTextFieldDisable())
            .lineLimit(textFieldLimit)
            .padding(padding)
            .background(Color("Gray"))
            .cornerRadius(cornerRadius)
            .keyboardType(.default)
            .disableAutocorrection(true)
            .autocapitalization(.none)
          Button(action: sendPrompt) {
            Image(systemName: "paperplane.circle.fill")
              .resizable()
              .frame(width: buttonSize, height: buttonSize)
          }
          .disabled(viewModel.isButtonDisable())
          .alert(viewModel.alertInfo, isPresented: $viewModel.isShowAlert) {
            Button("OK", role: .cancel) { }
          }
          .overlay() {
            if viewModel.isShowLoading {
              ProgressView()
            }
          }
          Spacer()
        }
        ImageView(isShowBrowser: $isShowBrowser, selectImage: $selectImage, urlImages: $viewModel.imagesURL, images: $images)
        Spacer()
      }
      .background(
        Color("White")
          .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
          }
      )
      .ignoresSafeArea(.keyboard, edges: .bottom)
      .navigationTitle("Image")
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(trailing: Menu {
        Picker("Number: \(String(viewModel.imageSet.number))", selection: $viewModel.imageSet.number) {
          ForEach(numberList, id: \.self) { num in
            Text("\(num)")
          }
        }
        .pickerStyle(.menu)
        .onChange(of: viewModel.imageSet.number) { _ in
          Task {
            images = .init(repeating: Image(systemName: "arrow.clockwise"), count: viewModel.imageSet.number)
            await StorageManager.storeImageSet(viewModel.imageSet)
          }
        }
        Picker("Size: \(viewModel.imageSet.size)", selection: $viewModel.imageSet.size) {
          ForEach(sizeList, id: \.self) { str in
            Text("\(str)")
          }
        }
        .pickerStyle(.menu)
        .onChange(of: viewModel.imageSet.size) { _ in
          Task {
            await StorageManager.storeImageSet(viewModel.imageSet)
          }
        }
      } label: {
        Image(systemName: "ellipsis")
      })
      .gesture(DragGesture().onChanged{ _ in
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      })
    }
  }
  
  func sendPrompt() {
    viewModel.sendPrompt(textField)
    textField = ""
    images = .init(repeating: Image(systemName: "arrow.clockwise"), count: StorageManager.restoreImageSet().number)
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

struct ImageChatView_Previews: PreviewProvider {
  static var previews: some View {
    ImageChatMainView(viewModel: ImageChatMainViewModel(), isShowBrowser: .constant(false), selectImage: .constant(1), images: .constant([]), avatar: "")
  }
}
