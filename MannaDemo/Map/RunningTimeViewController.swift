//
//  RunningTimeViewController.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/03.
//

import UIKit
import Lottie

class RunningTimeViewController: UIViewController {
    var expectArrived = UILabel()
    var collectionView = MannaCollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.8, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    func attribute() {
        expectArrived.do {
            $0.text = "예상 도착 순위"
            $0.font = UIFont(name: "NotoSansKR-Medium", size: 17)
            $0.textColor = .black
        }
    }
    
    func layout() {
        [collectionView, expectArrived].forEach { view.addSubview($0) }
        
        expectArrived.snp.makeConstraints {
            $0.top.equalTo(view).offset(MannaDemo.convertHeigt(value: 33.68))
            $0.leading.equalTo(view).offset(MannaDemo.convertWidth(value: 25.11))
            $0.width.equalTo(MannaDemo.convertWidth(value: 200))
            $0.height.equalTo(MannaDemo.convertHeigt(value: 25))
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(expectArrived.snp.bottom).offset(MannaDemo.convertHeigt(value: 22.26))
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
}
