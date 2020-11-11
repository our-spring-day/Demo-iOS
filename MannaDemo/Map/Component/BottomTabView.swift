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
    var borderLineView = UIView()
    var state: state = .transit
    
    init() {
        super.init(frame: CGRect.zero)
        attribute()
        layout()
    }
    
    func attribute() {
        let insetAtt = MannaDemo.convertWidth(value: 13)
        
        borderLineView.do {
            $0.alpha = 0.5
            $0.backgroundColor = .lightGray
        }
        chat.do {
            $0.tag = 0
            $0.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
            $0.addTarget(self, action: #selector(didChatButtonClicked), for: .touchUpInside)
            
            $0.imageEdgeInsets = UIEdgeInsets(top: insetAtt, left: insetAtt, bottom: insetAtt, right: insetAtt)
        }
        runningTime.do {
            $0.tag = 1
            $0.setImage(#imageLiteral(resourceName: "man"), for: .normal)
            $0.addTarget(self, action: #selector(didTransitButtonClicked), for: .touchUpInside)
            $0.imageEdgeInsets = UIEdgeInsets(top: insetAtt, left: insetAtt, bottom: insetAtt, right: insetAtt)
        }
        ranking.do {
            $0.tag = 2
            $0.setImage(#imageLiteral(resourceName: "ranking"), for: .normal)
            $0.addTarget(self, action: #selector(didRankingButtonClicked), for: .touchUpInside)
            $0.imageEdgeInsets = UIEdgeInsets(top: insetAtt, left: insetAtt, bottom: insetAtt, right: insetAtt)
        }
        indicatorView.do {
            $0.backgroundColor = UIColor(named: "keyColor")
            $0.layer.cornerRadius = 2
            $0.layer.masksToBounds = true
        }
    }
    
    func layout() {
        [chat, runningTime, ranking, borderLineView, indicatorView].forEach { addSubview($0) }
        
        chat.snp.makeConstraints {
            $0.leading.equalTo(self).offset(MannaDemo.convertWidth(value: 40))
            $0.centerY.equalTo(self)
            $0.width.height.equalTo(MannaDemo.convertWidth(value: 40))
        }
        runningTime.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.centerY.equalTo(self)
            $0.width.height.equalTo(MannaDemo.convertWidth(value: 52))
        }
        ranking.snp.makeConstraints {
            $0.trailing.equalTo(self).offset(-MannaDemo.convertWidth(value: 40))
            $0.centerY.equalTo(self)
            $0.width.height.equalTo(MannaDemo.convertWidth(value: 48))
        }
        borderLineView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self)
            $0.height.equalTo(MannaDemo.convertHeight(value: 1))
        }
        indicatorView.snp.makeConstraints {
            $0.width.equalTo(MannaDemo.convertWidth(value: 32))
            $0.height.equalTo(MannaDemo.convertHeight(value: 4))
            $0.centerX.equalTo(runningTime)
            $0.top.equalTo(self).offset(-MannaDemo.convertHeight(value: 1))
        }
    }
    
    @objc func didChatButtonClicked() {
        state = .chat
        UIView.animate(withDuration: 0.12, delay: 0, options: .transitionCurlUp, animations: {
            self.indicatorView.snp.remakeConstraints {
                $0.width.equalTo(MannaDemo.convertWidth(value: 32))
                $0.height.equalTo(MannaDemo.convertHeight(value: 4))
                $0.centerX.equalTo(self.chat).offset(-5)
                $0.top.equalTo(self).offset(-MannaDemo.convertHeight(value: 1))
            }
            self.layoutIfNeeded()
        })
        { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCurlUp, animations: {
                self.indicatorView.snp.remakeConstraints {
                    $0.width.equalTo(MannaDemo.convertWidth(value: 32))
                    $0.height.equalTo(MannaDemo.convertHeight(value: 4))
                    $0.centerX.equalTo(self.chat).offset(3)
                    $0.top.equalTo(self).offset(-MannaDemo.convertHeight(value: 1))
                }
                self.layoutIfNeeded()
            })
            { _ in
                UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCurlUp, animations: {
                    self.indicatorView.snp.remakeConstraints {
                        $0.width.equalTo(MannaDemo.convertWidth(value: 32))
                        $0.height.equalTo(MannaDemo.convertHeight(value: 4))
                        $0.centerX.equalTo(self.chat)
                        $0.top.equalTo(self).offset(-MannaDemo.convertHeight(value: 1))
                    }
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func didTransitButtonClicked() {
        
        UIView.animate(withDuration: 0.12, delay: 0, options: .transitionCurlUp, animations: {
            self.indicatorView.snp.remakeConstraints {
                $0.width.equalTo(MannaDemo.convertWidth(value: 32))
                $0.height.equalTo(MannaDemo.convertHeight(value: 4))
                $0.centerX.equalTo(self.runningTime).offset(self.state == .chat ? 5 : -5)
                $0.top.equalTo(self).offset(-MannaDemo.convertHeight(value: 1))
            }
            self.layoutIfNeeded()
        })
        { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCurlUp, animations: {
                self.indicatorView.snp.remakeConstraints {
                    $0.width.equalTo(MannaDemo.convertWidth(value: 32))
                    $0.height.equalTo(MannaDemo.convertHeight(value: 4))
                    $0.centerX.equalTo(self.runningTime).offset(self.state == .chat ? -3 : 3)
                    $0.top.equalTo(self).offset(-MannaDemo.convertHeight(value: 1))
                }
                self.layoutIfNeeded()
            })
            { _ in
                UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCurlUp, animations: {
                    self.indicatorView.snp.remakeConstraints {
                        $0.width.equalTo(MannaDemo.convertWidth(value: 32))
                        $0.height.equalTo(MannaDemo.convertHeight(value: 4))
                        $0.centerX.equalTo(self.runningTime)
                        $0.top.equalTo(self).offset(-MannaDemo.convertHeight(value: 1))
                    }
                    self.layoutIfNeeded()
                },completion: { _ in
                    self.state = .transit
                })
            }
        }
    }
    
    @objc func didRankingButtonClicked() {
        state = .ranking
        
        UIView.animate(withDuration: 0.12, delay: 0, options: .transitionCurlUp, animations: {
            self.indicatorView.snp.remakeConstraints {
                $0.width.equalTo(MannaDemo.convertWidth(value: 32))
                $0.height.equalTo(MannaDemo.convertHeight(value: 4))
                $0.centerX.equalTo(self.ranking).offset(5)
                $0.top.equalTo(self).offset(-MannaDemo.convertHeight(value: 1))
            }
            self.layoutIfNeeded()
        })
        { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCurlUp, animations: {
                self.indicatorView.snp.remakeConstraints {
                    $0.width.equalTo(MannaDemo.convertWidth(value: 32))
                    $0.height.equalTo(MannaDemo.convertHeight(value: 4))
                    $0.centerX.equalTo(self.ranking).offset(-3)
                    $0.top.equalTo(self).offset(-MannaDemo.convertHeight(value: 1))
                }
                self.layoutIfNeeded()
            })
            { _ in
                UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCurlUp, animations: {
                    self.indicatorView.snp.remakeConstraints {
                        $0.width.equalTo(MannaDemo.convertWidth(value: 32))
                        $0.height.equalTo(MannaDemo.convertHeight(value: 4))
                        $0.centerX.equalTo(self.ranking)
                        $0.top.equalTo(self).offset(-MannaDemo.convertHeight(value: 1))
                    }
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
