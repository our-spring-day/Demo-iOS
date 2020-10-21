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
    }
    let completeButton = UIButton().then {
        $0.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        $0.setTitle("닉네임 입력 완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(complete), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        
    }

    func layout() {
        view.addSubview(userName)
        view.addSubview(completeButton)
        
        userName.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(100)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
        completeButton.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
    }
    
    @objc func complete() {
        
    }
}
