//
//  CreateMannaViewController.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/21.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

class CreateMannaViewController: UIViewController {
    var textField = UITextField()
    var parentView: reloadData?
    var guideLabel = UILabel()
    var clearTextButton = UIButton()
    var completeBUtton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        attribute()
        layout()
    }
    
    func attribute() {
        view.do {
            $0.backgroundColor = .black
            $0.alpha = 0.8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.cornerRadius = 30
            $0.layer.masksToBounds = true
        }
        guideLabel.do {
            $0.font = UIFont.boldSystemFont(ofSize: 25)
            $0.text = "원하는 제목을 입력하세요 "
        }
        textField.do {
            $0.attributedPlaceholder = NSAttributedString(string: "약속 제목을 입력하세욧", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            $0.textAlignment = .center
            $0.delegate = self
        }
        clearTextButton.do {
            $0.setImage(#imageLiteral(resourceName: "Image-6"), for: .normal)
            $0.addTarget(self, action: #selector(didClickedBackButton), for: .touchUpInside)
        }
    }
    
    func layout() {
        view.addSubview(textField)
        view.addSubview(guideLabel)
        view.addSubview(clearTextButton)
        
        textField.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(70)
            $0.top.equalTo(guideLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(view.snp.centerX)
        }
        guideLabel.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(70)
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        clearTextButton.snp.makeConstraints {
            $0.centerY.equalTo(textField)
            $0.leading.equalTo(textField.snp.trailing).offset(10)
            $0.height.width.equalTo(25)
        }
    }
    
    func postManna() {
        guard let deviceID = KeychainWrapper.standard.string(forKey: "device_id") else { return }
        
        var param: Parameters = [
                "device_id" : deviceID,
                "manna_name" : textField.text
            ]
        
        let result = AF.request("http://ec2-13-124-151-24.ap-northeast-2.compute.amazonaws.com:8888/manna", method: .post, parameters: param, encoding: JSONEncoding.default)
        
        result.responseJSON() { response in
                print("JSON = \(try! response.result.get())")
            if let jsonObject = try! response.result.get()  as? [String: Any] {
                print("타임스탬프 : \(jsonObject["create_timestamp"]!)")
                print("만나네임 : \(jsonObject["manna_name"]!)")
                print("uuid : \(jsonObject["uuid"]!)")
                MannaModel.model.append(Manna(time: "\(jsonObject["create_timestamp"]!)", name: "\(jsonObject["manna_name"]!)") )
                 
            }
        }
    }
    @objc func didClickedBackButton() {
        textField.text = ""
    }
}

extension CreateMannaViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postManna()
        self.view.endEditing(true)
        self.dismiss(animated: true,completion: {
            self.parentView?.reloadData()
        })
        return true
    }
}
