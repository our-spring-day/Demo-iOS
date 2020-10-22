//
//  UUID.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/23.
//

import UIKit
import SwiftKeychainWrapper

class MyUUID {
    static var uuid = KeychainWrapper.standard.string(forKey: "device_id")
}
