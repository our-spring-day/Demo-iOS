//
//  PaddingLabel.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/12/09.
//

import UIKit

class PaddingLabel: UILabel {
    var insets = UIEdgeInsets.init(top: 5.0, left: 7.0, bottom: 8.0, right: 3)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += insets.top + insets.bottom
        contentSize.width += insets.left + insets.right
        return contentSize
    }
    
}
