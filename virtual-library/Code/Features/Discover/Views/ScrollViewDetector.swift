//
//  ScrollViewDetector.swift
//  virtual-library
//
//  Created by Riley Jenum on 23/10/24.
//

import Foundation
import UIKit
import SwiftUI

struct ScrollViewDetector: UIViewRepresentable {
    @Binding var carouselMode: Bool
    var totalCardCount: Int
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView {
                scrollView.decelerationRate = carouselMode ? .fast : .normal
                if carouselMode {
                    scrollView.delegate = context.coordinator
                } else {
                    scrollView.delegate = nil
                }
                context.coordinator.totalCount = totalCardCount
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollViewDetector
        var totalCount: Int = 0
        var velocityY: CGFloat = 0
        init(parent: ScrollViewDetector) {
            self.parent = parent
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            let cardHeight: CGFloat = 220
            let cardSpacing: CGFloat = 35
            let targetEnd: CGFloat = scrollView.contentOffset.y + (velocity.y * 60 )
            let index = (targetEnd / cardHeight).rounded()
            let modifiedEnd = index * cardHeight
            let spacing = cardSpacing * index
            
            targetContentOffset.pointee.y = modifiedEnd + spacing
            velocityY = velocity.y
        }
        
        func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
            let cardHeight: CGFloat = 220
            let cardSpacing: CGFloat = 35
            let targetEnd: CGFloat = scrollView.contentOffset.y + (velocityY * 60 )
            let index = max(min((targetEnd / cardHeight).rounded(), CGFloat(totalCount)), 0.0)
            let modifiedEnd = index * cardHeight
            let spacing = cardSpacing * index
            
            scrollView.setContentOffset(.init(x: 0, y: modifiedEnd + spacing), animated: true)
        }
    }
}
