//
//  RegisterUserViewController.swift
//  MannaDemo
//
//  Created by once on 2020/10/21.
//

import UIKit
import Alamofire
import SnapKit
import Then

class RegisterUserViewController: UIViewController {

    let userName = UITextField().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        $0.textAlignment = .center
        $0.placeholder = "닉네임 입력"
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let completeButton = UIButton().then {
        $0.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        $0.setTitle("닉네임 입력 완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(input), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
