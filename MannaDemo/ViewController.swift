//
//  ViewController.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/21.
//

import UIKit
import SwiftKeychainWrapper

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        KeychainWrapper.standard.removeObject(forKey: "device_id")
    }
}

