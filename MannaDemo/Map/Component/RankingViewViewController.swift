//
//  RankingViewViewController.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/03.
//

import UIKit
import Lottie

class RankingViewViewController: UIViewController {
    
    var guide = UILabel()
    var airplaneGuide = UILabel()
    var animationView = AnimationView(name:"12670-flying-airplane")
    
    override func viewDidLoad() {
        guide.do {
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            $0.text = "화면 준비중이에요 😭"
            $0.textAlignment = .center
            $0.textColor = .black
        }
        airplaneGuide.do {
            $0.font = UIFont.boldSystemFont(ofSize: 10)
            $0.text = "아래 비행기를 클릭하면 이미지가 토글돼요"
            $0.textAlignment = .center
            $0.textColor = UIColor(named: "keyColor")
        }
        
        [guide, airplaneGuide, animationView].forEach { view.addSubview($0) }
        
        guide.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(100)
            $0.centerX.equalTo(view)
            $0.width.equalTo(200)
            $0.height.equalTo(100)
        }
        animationView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(50)
            $0.centerX.equalTo(view)
            $0.width.height.equalTo(75)
        }
        
        airplaneGuide.snp.makeConstraints {
            $0.bottom.equalTo(animationView.snp.top).offset(10)
            $0.centerX.equalTo(view)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        lottieFunc()
    }
    func lottieFunc() {
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.loopMode = .loop
    }
}
