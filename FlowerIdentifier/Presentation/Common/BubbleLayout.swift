//
//  BubbleLayout.swift
//  writeai
//
//  Created by Eilon Krauthammer on 30/06/2023.
//

import SwiftUI

struct BubbleLayout: Layout {
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat
    let horizontalOffset: CGFloat
    let verticalOffset: CGFloat
    let numberOfRows: Int
    
    init(horizontalSpacing: CGFloat,
         verticalSpacing: CGFloat,
         horizontalOffset: CGFloat,
         verticalOffset: CGFloat = 20,
         numberOfRows: Int = 2) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.horizontalOffset = horizontalOffset
        self.verticalOffset = verticalOffset
        self.numberOfRows = numberOfRows
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxNumberOfItemsInRow = Int((Float(subviews.count) / Float(numberOfRows)).rounded(.up))
        let totalWidth: CGFloat = subviews[0..<maxNumberOfItemsInRow].reduce(.zero) { current, subview in
            return current + subview.sizeThatFits(.unspecified).width + horizontalSpacing
        }
        
        var width = totalWidth - horizontalSpacing
        if numberOfRows > 1 {
            width += horizontalOffset
        }
        
        let maxSubviewHeight = subviews.max {
            $0.sizeThatFits(.unspecified).height > $1.sizeThatFits(.unspecified).height
        }?.sizeThatFits(.unspecified).height ?? 0
        
        var height = (maxSubviewHeight * CGFloat(numberOfRows)) + (verticalSpacing * CGFloat(numberOfRows - 1))
        let numberOfColumns = subviews.count / numberOfRows
        if numberOfColumns > 2 {
            height += verticalOffset
        }
        
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var rows = [Int: CGFloat]()
        
        for (index, subview) in subviews.enumerated() {
            let subviewSize = subview.sizeThatFits(.unspecified)
            let sizeProposal = ProposedViewSize(subviewSize)
            let rowIndex = index % numberOfRows
            let columnIndex = index / numberOfRows
            let x = rows[rowIndex] ?? (index % 2 == 0 ? bounds.minX : bounds.minX + horizontalOffset)
            var y = (subviewSize.height * CGFloat(rowIndex)) + (verticalSpacing * CGFloat(rowIndex))
            if columnIndex % 2 == 0 {
                y += verticalOffset
            }
            
            let placement = CGPoint(x: x, y: y)
            rows[rowIndex] = x + subviewSize.width + horizontalSpacing
            
            subview.place(at: placement, proposal: sizeProposal)
        }
    }
}
