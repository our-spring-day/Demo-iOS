//
//  ChatButton.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/19.
//

import UIKit

class BottomBar: UIView {
    var chatButton = UIButton()
    var rankingButton = UIButton()
    var timerView = TimerView(.mapView)
    
    func attribute() {
        chatButton.do {
            $0.backgroundColor = .white
            $0.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
            $0.layer.cornerRadius = MannaDemo.convertHeight(value: 53) / 2
            $0.layer.masksToBounds = true
            $0.imageEdgeInsets = UIEdgeInsets(top: MannaDemo.convertHeight(value: 17), left: MannaDemo.convertHeight(value: 16.5), bottom: MannaDemo.convertHeight(value: 16), right: MannaDemo.convertHeight(value: 16.5))
            $0.dropShadow()
            $0.tag = 1
        }
        rankingButton.do {
            $0.backgroundColor = .white
            $0.setImage(#imageLiteral(resourceName: "ranking"), for: .normal)
            $0.layer.cornerRadius = MannaDemo.convertHeight(value: 53) / 2
            $0.layer.masksToBounds = true
            $0.imageEdgeInsets = UIEdgeInsets(top: MannaDemo.convertHeight(value: 15), left: MannaDemo.convertHeight(value: 14.5), bottom: MannaDemo.convertHeight(value: 14.5), right: MannaDemo.convertHeight(value: 14.5))
            $0.dropShadow()
            $0.tag = 2
        }
    }
    
    func layout() {
        [rankingButton, chatButton, timerView].forEach { addSubview($0) }
        
        rankingButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-34)
            $0.leading.equalTo(chatButton.snp.trailing).offset(MannaDemo.convertWidth(value: 10))
            $0.width.height.equalTo(MannaDemo.convertHeight(value: 54))
        }
        chatButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-34)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.width.height.equalTo(MannaDemo.convertHeight(value: 54))
        }
        timerView.snp.makeConstraints {
            $0.centerY.equalTo(chatButton.snp.centerY)
            $0.trailing.equalTo(self).offset(-20)
            $0.width.equalTo(MannaDemo.convertWidth(value: MannaDemo.convertWidth(value: 111)))
            $0.height.equalTo(MannaDemo.convertHeight(value: MannaDemo.convertWidth(value: 48)))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
