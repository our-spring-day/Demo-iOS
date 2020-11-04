//
//  tempViewController.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/03.
//

import UIKit

class tempViewController: UIViewController {
    var backgroundView = UIImageView()
    var bar = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        view.do {
//            $0.layer.cornerRadius = 20
//            $0.layer.masksToBounds = true
//        }
        backgroundView.do {
            $0.image = #imageLiteral(resourceName: "bottomsheet")
        }
        bar.do {
            $0.image = #imageLiteral(resourceName: "bottomsheetbar")
        }
        
        
        [backgroundView].forEach { view.addSubview($0) }
        [bar].forEach { backgroundView.addSubview($0) }
        
        bar.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.top).offset(11.5)
            $0.centerX.equalTo(self.view)
            $0.width.equalTo(MannaDemo.convertWidth(value: 60))
            $0.height.equalTo(MannaDemo.convertHeigt(value: 5))
        }
    }
}
