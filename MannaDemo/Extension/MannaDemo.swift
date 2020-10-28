//
//  MannaDemo.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/27.
//

import UIKit
import SwiftKeychainWrapper

class MannaDemo {
    static let screenSize = UIScreen.main.bounds
    
    static var myUUID = KeychainWrapper.standard.string(forKey: "device_id")
    
    static func convertHeigt(value: CGFloat) -> CGFloat{
        return screenSize.height * (value / 812)
    }
    
    static func convertWidth(value: CGFloat) -> CGFloat {
        return screenSize.width * (value / 375)
    }
}
