//
//  tempViewController.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/03.
//

import UIKit

class tempViewController: UIViewController {
    var backgroundView = UIView()
    var bar = UIImageView()
    var backButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        backgroundView.do {
            $0.isUserInteractionEnabled = true
        }
        bar.do {
            $0.image = #imageLiteral(resourceName: "bottomsheetbar")
        }
        backButton.do {
            $0.setTitle("back", for: .normal)
            $0.backgroundColor = .cyan
            $0.addTarget(self, action: #selector(back), for: .touchUpInside)
            $0.isUserInteractionEnabled = true
        }
    
        [backgroundView, backButton].forEach { view.addSubview($0) }
        [bar].forEach { backgroundView.addSubview($0) }
        
        bar.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.top).offset(11.5)
            $0.centerX.equalTo(self.view)
            $0.width.equalTo(MannaDemo.convertWidth(value: 60))
            $0.height.equalTo(MannaDemo.convertHeigt(value: 5))
        }
        backButton.snp.makeConstraints {
            $0.top.equalTo(bar.snp.bottom).offset(30)
            $0.centerX.equalTo(view)
            $0.width.height.equalTo(100)
        }
    }
    
    @objc func back() {
        self.dismiss(animated: true)
    }
}
