//
//  TimerView.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/05.
//

import UIKit

enum TimerAtwhere {
    case mapView
    case rankingView
}

class TimerView: UIView {
    static var shared = TimerView(.mapView)
    var minuteLabel = UILabel()
    var secondLabel = UILabel()
    var colon = UILabel()
    var whereAt: TimerAtwhere?
    var checkIn = UILabel()
    var tempToggleFlag = false {
        didSet {
            didChangedTempToggleFlag()
        }
    }
    
    init(_ at: TimerAtwhere) {
        super.init(frame: CGRect.zero)
        whereAt = at
        attribute()
        layout()
        timer()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timer), userInfo: nil, repeats: true)
    }
    
    @objc func didChangedTempToggleFlag() {
        tempToggleFlag == true ? [secondLabel, minuteLabel, colon].forEach { $0.isHidden = true } : [secondLabel, minuteLabel, colon].forEach { $0.isHidden = false }
        checkIn.isHidden = tempToggleFlag == true ? false : true
    }
    
    @objc func timer() {
        let miniuteFormatter = DateFormatter()
        let secondFormatter = DateFormatter()
        miniuteFormatter.dateFormat = "mm"
        secondFormatter.dateFormat = "ss"
        let minute = miniuteFormatter.string(from: Date())
        let second = secondFormatter.string(from: Date())
        
        minuteLabel.text = "\(59 - Int(minute)!)"
        secondLabel.text = "\(59 - Int(second)!)"
        
        if (59 - Int(minute)!) > 9 && (59 - Int(minute)!) < 19 {
            switch whereAt {
            case .mapView:
                self.backgroundColor = UIColor(named: "20minute")
                break
            case .rankingView:
                [minuteLabel, secondLabel, colon].forEach { $0.textColor = UIColor(named: "20minute") }

                break
            case .none:
                print("타이머의 whereAt 변수를 할당하세요")
            }
        } else if (59 - Int(minute)!) < 10 {
            switch whereAt {
            case .mapView:
                self.backgroundColor = UIColor(named: "10minute")
                break
            case .rankingView:
                [minuteLabel, secondLabel, colon].forEach { $0.textColor = UIColor(named: "10minute") }
                break
            case .none:
                print("타이머의 whereAt 변수를 할당하세요")
            }
        } else {
            switch whereAt {
            case .mapView:
                self.backgroundColor = UIColor(named: "keyColor")
                break
            case .rankingView:
                [minuteLabel, secondLabel, colon].forEach { $0.textColor = UIColor(named: "keyColor") }
                break
            case .none:
                print("타이머의 whereAt 변수를 할당하세요")
            }
        }
    }
    
    func attribute() {
        self.do {
            $0.layer.cornerRadius = 24
            $0.layer.masksToBounds = true
            switch whereAt {
            case .mapView:
                $0.backgroundColor = UIColor(named: "keyColor")
                $0.dropShadow()
            case .rankingView:
                var viewBlurEffect = UIVisualEffectView()
                viewBlurEffect.effect = UIBlurEffect(style: .dark)
                self.addSubview(viewBlurEffect)
                viewBlurEffect.frame = self.bounds
                [minuteLabel, secondLabel, colon].forEach { $0.textColor = UIColor(named: "keyColor") }
                $0.dropShadow()
            case .none:
                print("타이머의 whereAt 변수를 할당하세요")
            }
        }
        
        [minuteLabel, secondLabel].forEach {
            $0.do {
                $0.font = UIFont(name: "SFProDisplay-Semibold", size: 19)
                $0.textAlignment = .center
                $0.textColor = .white
            }
        }
        [colon].forEach {
            $0.text = ":"
            $0.font = UIFont(name: "SFProDisplay-Semibold", size: 19)
            $0.textAlignment = .center
            $0.textColor = .white
        }
        checkIn.do {
            $0.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
            $0.textAlignment = .center
            $0.textColor = .white
            $0.text = "체크인 하기"
            $0.isHidden = true
        }
    }
    
    func layout() {
        [minuteLabel, secondLabel, colon, checkIn].forEach { addSubview($0) }
        
        minuteLabel.snp.makeConstraints {
            $0.leading.equalTo(self)
            $0.trailing.equalTo(colon.snp.leading).offset(15)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalTo(20)
        }
        secondLabel.snp.makeConstraints {
            $0.trailing.equalTo(self)
            $0.leading.equalTo(colon.snp.trailing).offset(-15)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
        colon.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self)
            $0.width.equalTo(5)
            $0.height.equalTo(30)
        }
        checkIn.snp.makeConstraints {
            $0.width.height.centerX.centerY.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
