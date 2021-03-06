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
    case messageSendButton
    case urgentOn
    case urgentOff
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
        case .messageSendButton:
            return #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        case .urgentOn:
            return #colorLiteral(red: 0.3529411765, green: 0.4196078431, blue: 1, alpha: 0.1)
        case .urgentOff:
            return #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 0.1)
        }     
    }
}

