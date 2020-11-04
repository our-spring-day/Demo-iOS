//
//  BottomTabView.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/03.
//

import UIKit
import SnapKit

enum state {
    case chat
    case transit
    case ranking
}
class BottomTabView: UIView {
    var chat = UIButton()
    var runningTime = UIButton()
    var ranking = UIButton()
    var indicatorView = UIView()
    var state: state = .transit
    
    init() {
        super.init(frame: CGRect.zero)
        attribute()
        layout()
    }
    
    func attribute() {
        self.do {
            $0.layer.borderWidth = MannaDemo.convertHeigt(value: 1)
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.bringSubviewToFront(indicatorView)
        }
        chat.do {
            $0.tag = 0
            $0.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
            $0.addTarget(self, action: #selector(didChatButtonClicked), for: .touchUpInside)
        }
        runningTime.do {
            $0.tag = 1
            $0.setImage(#imageLiteral(resourceName: "bus"), for: .normal)
            $0.addTarget(self, action: #selector(didTransitButtonClicked), for: .touchUpInside)
        }
        ranking.do {
            $0.tag = 2
            $0.setImage(#imageLiteral(resourceName: "ranking"), for: .normal)
            $0.addTarget(self, action: #selector(didRankingButtonClicked), for: .touchUpInside)
        }
        indicatorView.do {
            $0.backgroundColor = UIColor(named: "keyColor")
            $0.layer.cornerRadius = 2
            $0.layer.masksToBounds = true
        }
    }
    
    func layout() {
        [chat, runningTime, ranking, indicatorView].forEach { addSubview($0) }
        
        chat.snp.makeConstraints {
            $0.leading.equalTo(self).offset(MannaDemo.convertWidth(value: 40))
            $0.bottom.equalTo(self).offset(-MannaDemo.convertHeigt(value: 33))
            $0.width.height.equalTo(MannaDemo.convertWidth(value: 20))
        }
        runningTime.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.bottom.equalTo(self).offset(-MannaDemo.convertHeigt(value: 33))
            $0.width.height.equalTo(MannaDemo.convertWidth(value: 24))
        }
        ranking.snp.makeConstraints {
            $0.trailing.equalTo(self).offset(-MannaDemo.convertWidth(value: 40))
            $0.bottom.equalTo(self).offset(-MannaDemo.convertHeigt(value: 33))
            $0.width.height.equalTo(MannaDemo.convertWidth(value: 24))
        }
        indicatorView.snp.makeConstraints {
            $0.width.equalTo(MannaDemo.convertWidth(value: 32))
            $0.height.equalTo(MannaDemo.convertHeigt(value: 4))
            $0.centerX.equalTo(runningTime)
            $0.top.equalTo(self).offset(-MannaDemo.convertHeigt(value: 1))
        }
    }
    
    @objc func didChatButtonClicked() {
        state = .chat
        UIView.animate(withDuration: 0.3) {
            self.indicatorView.snp.remakeConstraints {
                $0.width.equalTo(MannaDemo.convertWidth(value: 32))
                $0.height.equalTo(MannaDemo.convertHeigt(value: 4))
                $0.centerX.equalTo(self.chat)
                $0.top.equalTo(self).offset(-MannaDemo.convertHeigt(value: 1))
            }
            self.layoutIfNeeded()
        }
    }
    
    @objc func didTransitButtonClicked() {
        state = .transit
        UIView.animate(withDuration: 0.3) {
            self.indicatorView.snp.remakeConstraints {
                $0.width.equalTo(MannaDemo.convertWidth(value: 32))
                $0.height.equalTo(MannaDemo.convertHeigt(value: 4))
                $0.centerX.equalTo(self.runningTime)
                $0.top.equalTo(self).offset(-MannaDemo.convertHeigt(value: 1))
            }
            self.layoutIfNeeded()
        }
    }
    
    @objc func didRankingButtonClicked() {
        state = .ranking
        UIView.animate(withDuration: 0.3) {
            self.indicatorView.snp.remakeConstraints {
                $0.width.equalTo(MannaDemo.convertWidth(value: 32))
                $0.height.equalTo(MannaDemo.convertHeigt(value: 4))
                $0.centerX.equalTo(self.ranking)
                $0.top.equalTo(self).offset(-MannaDemo.convertHeigt(value: 1))
            }
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
