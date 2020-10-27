//
//  MannaDemo.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/27.
//

import UIKit

class MannaDemo {
    static let screenSize = UIScreen.main.bounds
    
    static func convertHeigt(value: CGFloat) -> CGFloat{
        return screenSize.height * (value / 812)
    }
    
    static func convertWidth(value: CGFloat) -> CGFloat {
        return screenSize.width * (value / 375)
    }
}
