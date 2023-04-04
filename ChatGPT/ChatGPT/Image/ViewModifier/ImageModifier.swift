//
//  ImageModifier.swift
//  ChatGPT
//
//  Created by Wenyan Zhao on 2023/4/3.
//

import SwiftUI
import UIKit

struct ImageModifier: ViewModifier {
  @State var currentScale: CGFloat = 1
  @Binding var isShow: Bool
  private var contentSize: CGSize
  private var minScale: CGFloat = 1
  private var maxScale: CGFloat = 3
  
  init(isShow: Binding<Bool>, contentSize: CGSize) {
    self._isShow = isShow
    self.contentSize = contentSize
  }
  
  var doubleTapGesture: some Gesture {
    TapGesture(count: 2)
      .onEnded {
        if currentScale <= minScale {
          currentScale = maxScale
        } else if currentScale >= maxScale {
          currentScale = minScale
        } else {
          currentScale = ((maxScale - minScale) / 2 + minScale) < currentScale ? maxScale : minScale
        }
      }
  }
  
  func body(content: Content) -> some View {
    ScrollView([.horizontal, .vertical], showsIndicators: false) {
      content
        .frame(width: contentSize.width * currentScale, height: contentSize.height * currentScale, alignment: .center)
        .modifier(PinchToZoom(scale: $currentScale, minScale: minScale, maxScale: maxScale))
    }
    .gesture(doubleTapGesture)
    .onTapGesture {
      isShow = false
    }
    .animation(.easeInOut, value: currentScale)
  }
}

class PinchZoomView: UIView {
  let minScale: CGFloat
  let maxScale: CGFloat
  var isPinching: Bool = false
  var scale: CGFloat = 1
  let scaleChange: (CGFloat) -> Void
  
  init(minScale: CGFloat,
       maxScale: CGFloat,
       currentScale: CGFloat,
       scaleChange: @escaping (CGFloat) -> Void) {
    self.minScale = minScale
    self.maxScale = maxScale
    self.scale = currentScale
    self.scaleChange = scaleChange
    super.init(frame: .zero)
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
    pinchGesture.cancelsTouchesInView = false
    addGestureRecognizer(pinchGesture)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  @objc private func pinch(gesture: UIPinchGestureRecognizer) {
    switch gesture.state {
    case .began:
      isPinching = true
    case .changed, .ended:
      if gesture.scale <= minScale {
        scale = minScale
      } else if gesture.scale >= maxScale {
        scale = maxScale
      } else {
        scale = gesture.scale
      }
      scaleChange(scale)
    case .cancelled, .failed:
      isPinching = false
      scale = 1
    default:
      break
    }
  }
}

struct PinchZoom: UIViewRepresentable {
  @Binding var scale: CGFloat
  @Binding var isPinching: Bool
  let minScale: CGFloat
  let maxScale: CGFloat
  
  func makeUIView(context: Context) -> PinchZoomView {
    let pinchZoomView = PinchZoomView(minScale: minScale, maxScale: maxScale, currentScale: scale, scaleChange: { scale = $0 })
    return pinchZoomView
  }
  
  func updateUIView(_ pageControl: PinchZoomView, context: Context) { }
}

struct PinchToZoom: ViewModifier {
  @Binding var scale: CGFloat
  @State var anchor: UnitPoint = .center
  @State var isPinching: Bool = false
  let minScale: CGFloat
  let maxScale: CGFloat
  
  func body(content: Content) -> some View {
    content
      .scaleEffect(scale, anchor: anchor)
      .animation(.spring(), value: isPinching)
      .overlay(PinchZoom(scale: $scale, isPinching: $isPinching, minScale: minScale, maxScale: maxScale))
      .onDisappear {
        scale = 1
      }
  }
}

