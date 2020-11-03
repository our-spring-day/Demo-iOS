//
//  UIColor+Ext.swift
//  MannaDemo
//
//  Created by once on 2020/11/03.
//

import UIKit

enum AssetsColor {
    case receiveMessage
    case sendMessage
    case chatName
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor {
        switch name {
        case .receiveMessage:
            return #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 1, alpha: 1)
        case .sendMessage:
            return #colorLiteral(red: 0.4117647059, green: 0.4745098039, blue: 1, alpha: 1)
        case .chatName:
            return #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        }
        
    }
}

