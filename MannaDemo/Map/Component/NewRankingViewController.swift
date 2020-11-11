//
//  NewRankingViewController.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/11.
//

import UIKit

class NewRankingViewViewController: UIViewController {
    var dismissButton = UIButton()
    var timerView = TimerView(.rankingView)
    override func viewDidLoad() {
        attribute()
        layout()
    }
    
    func attribute() {
        dismissButton.do {
            $0.setImage(#imageLiteral(resourceName: "dismiss"), for: .normal)
            $0.layer.cornerRadius = $0.frame.width / 2
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(dismissRakingView), for: .touchUpInside)
            $0.imageEdgeInsets = UIEdgeInsets(top: MannaDemo.convertHeight(value: 18.02), left: MannaDemo.convertHeight(value: 14.37), bottom: MannaDemo.convertHeight(value: 18.94), right: MannaDemo.convertHeight(value: 14.57))
        }
    }
    
    func layout() {
        [dismissButton, timerView].forEach { view.addSubview($0) }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(46)
            $0.leading.equalToSuperview().offset(15)
            $0.width.height.equalTo(MannaDemo.convertHeight(value: 45))
        }
        timerView.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.centerY.equalTo(dismissButton)
            $0.width.equalTo(MannaDemo.convertWidth(value: 102))
            $0.height.equalTo(MannaDemo.convertHeight(value: 45))
        }
    }
    
    @objc func dismissRakingView() {
        self.dismiss(animated: true) {
        }
    }
}
