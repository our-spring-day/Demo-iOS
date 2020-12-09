//
//  LeftAlignCollectionViewFlowLayout.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/12/09.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        scrollDirection = .horizontal
        var topMargin = sectionInset.top
        var maxX: CGFloat = -1.0
        self.minimumInteritemSpacing = 20
        self.minimumLineSpacing = 30
        
        for i in 0...attributes!.count - 1 {
            if attributes![i].frame.origin.x >= maxX {
                topMargin = sectionInset.top
            }
            attributes![i].frame.origin.y = topMargin
            if i > 3 {
//                if standard = attributes![i-4] {
                    attributes![i].frame.origin.x = attributes![i-4].frame.minX + attributes![i-4].frame.width + minimumInteritemSpacing
//                }
            } else {
                attributes![i].frame.origin.x = 0
            }
            
            topMargin += attributes![i].frame.height + minimumLineSpacing
            maxX = max(attributes![i].frame.maxX , maxX)
        }
        
//        attributes?.forEach { layoutAttribute in
//            if layoutAttribute.frame.origin.x >= maxX {
//                topMargin = sectionInset.top
//            }
//            layoutAttribute.frame.origin.y = topMargin
//            topMargin += layoutAttribute.frame.height + minimumLineSpacing
//            maxX = max(layoutAttribute.frame.maxX , maxX)
//        }
        
        return attributes
    }
}
