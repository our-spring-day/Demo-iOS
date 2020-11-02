//
//  BottomTabView.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/03.
//

import UIKit
import SnapKit

class BottomTabView: UIView {
    var chat = UIButton()
    var transit = UIButton()
    var ranking = UIButton()
    
    init() {
        super.init(frame: CGRect.zero)
        attribute()
        layout()
    }
    
    func attribute() {
        self.do {
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.gray.cgColor
        }
        chat.do {
            $0.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        }
        transit.do {
            $0.setImage(#imageLiteral(resourceName: "bus"), for: .normal)
        }
        ranking.do {
            $0.setImage(#imageLiteral(resourceName: "ranking"), for: .normal)
        }
    }
    
    func layout() {
        [chat, transit, ranking].forEach { addSubview($0) }
        
        chat.snp.makeConstraints {
            $0.leading.equalTo(self).offset(MannaDemo.convertWidth(value: 40))
            $0.bottom.equalTo(self).offset(-MannaDemo.convertHeigt(value: 33))
//            $0.centerY.equalTo(self)
            $0.width.height.equalTo(MannaDemo.convertWidth(value: 20))
        }
        transit.snp.makeConstraints {
            $0.centerX.equalTo(self)
//            $0.centerY.equalTo(self)
            $0.bottom.equalTo(self).offset(-MannaDemo.convertHeigt(value: 33))
            $0.width.height.equalTo(MannaDemo.convertWidth(value: 24))
        }
        ranking.snp.makeConstraints {
            $0.trailing.equalTo(self).offset(-MannaDemo.convertWidth(value: 40))
            $0.bottom.equalTo(self).offset(-MannaDemo.convertHeigt(value: 33))
//            $0.centerY.equalTo(self)
            $0.width.height.equalTo(MannaDemo.convertWidth(value: 24))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
