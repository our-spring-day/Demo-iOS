//
//  RankingViewViewController.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/03.
//

import UIKit

class RankingViewViewController: UIViewController {
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        button.do {
            $0.setTitle("파란", for: .normal)
            $0.backgroundColor = .gray
            $0.addTarget(self, action: #selector(test), for: .touchUpInside)
        }
        view.addSubview(button)
        
        button.snp.makeConstraints {
            $0.top.equalTo(view).offset(100)
            $0.width.centerX.equalTo(view)
            $0.height.equalTo(100)
        }
    }
    
    @objc func test() {
        print("ranking!!")
    }
    
}
