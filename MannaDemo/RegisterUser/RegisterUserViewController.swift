//
//  RegisterUserViewController.swift
//  MannaDemo
//
//  Created by once on 2020/10/21.
//

import UIKit
import Alamofire
import SnapKit
import SwiftKeychainWrapper
import Then

class RegisterUserViewController: UIViewController {
    let url = "http://ec2-13-124-151-24.ap-northeast-2.compute.amazonaws.com:8888/user"
    let userName = UITextField().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        $0.textAlignment = .center
        $0.placeholder = "닉네임 입력"
        $0.backgroundColor = .white
        $0.textColor = .black
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
        let view = UINavigationController(rootViewController: MannaListViewController())
        guard let deviceID = KeychainWrapper.standard.string(forKey: "device_id") else { return }
        guard let userName = userName.text else { return }
        
        let parameter: [String: String] = [
            "device_id": deviceID,
            "username": userName
        ]
        registerUser(parameter)
        print("등록완료!!!")
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true, completion: nil)
    }
    
    func registerUser(_ parameter: [String: String]) {
        AF.request(url,
                   method: .post,
                   parameters: parameter,
                   encoding: JSONEncoding.default).responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        print("\(value)")
                    case .failure(let err):
                        print("\(err)")
                    }
            }
    }
}
