//
//  AutomaticScroller.swift
//  writeai
//
//  Created by Eilon Krauthammer on 02/07/2023.
//

import UIKit

class AutomaticScroller {
    weak var scrollView: UIScrollView?
    
    private var displayLink: CADisplayLink?
    private let scrollOffsetPerLoop: CGFloat = 0.35
    
    func startScrolling() {
        displayLink = CADisplayLink(target: self, selector: #selector(scroll))
        displayLink?.add(to: .current, forMode: .common)
    }
    
    func stopScrolling() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func scroll() {
        guard let scrollView else {
            return
        }
        
        guard scrollView.contentOffset.x <= (scrollView.contentSize.width - scrollView.bounds.width) else {
            return
        }
        
        scrollView.contentOffset.x += scrollOffsetPerLoop
    }
}
