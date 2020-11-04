//
//  UILabel+Ext.swift
//  MannaDemo
//
//  Created by once on 2020/11/04.
//
//
import UIKit

extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}



//    func setLinespace(spacing: CGFloat) {
//        if let text = self.text {
//            let attributeString = NSMutableAttributedString(string: text)
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = spacing
//
//            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle,
//                                         value: paragraphStyle,
//                                         range: NSMakeRange(0, attributeString.length))
//
//            self.attributedText = attributeString
//        }
//    }
