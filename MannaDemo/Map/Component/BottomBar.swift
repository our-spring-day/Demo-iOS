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
    var borderView = UIView()
    
    func attribute() {
        self.do {
            $0.backgroundColor = .white
        }
        borderView.do {
            $0.backgroundColor = UIColor(named: "bottombarborder")
            $0.isHidden = true
        }
        chatButton.do {
            $0.backgroundColor = .white
            $0.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
            $0.layer.cornerRadius = 54 / 2
            $0.layer.masksToBounds = true
            $0.imageEdgeInsets = UIEdgeInsets(top: 17,
                                              left: 16.5,
                                              bottom: 16,
                                              right: 16.5)
            $0.dropShadow()
        }
        rankingButton.do {
            $0.backgroundColor = .white
            $0.setImage(#imageLiteral(resourceName: "ranking"), for: .normal)
            $0.layer.cornerRadius = 54 / 2
            $0.layer.masksToBounds = true
            $0.imageEdgeInsets = UIEdgeInsets(top: 15,
                                              left: 14.5,
                                              bottom: 14.5,
                                              right: 14.5)
            $0.dropShadow()
        }
    }
    
    func layout() {
        [rankingButton, chatButton, timerView, borderView].forEach { addSubview($0) }
        
        rankingButton.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.bottom).offset(MannaDemo.convertHeight(value: -26))
            $0.leading.equalTo(chatButton.snp.trailing).offset(8)
            $0.width.height.equalTo(54)
        }
        chatButton.snp.makeConstraints {
            $0.bottom.equalTo(rankingButton)
            $0.leading.equalTo(19)
            $0.width.height.equalTo(54)
        }
        timerView.snp.makeConstraints {
            $0.bottom.equalTo(rankingButton).offset(MannaDemo.convertHeight(value: -1))
            $0.trailing.equalTo(self).offset(-18)
            $0.width.equalTo(109)
            $0.height.equalTo(51)
        }
        borderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(self.snp.top).offset(-0.5)
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
