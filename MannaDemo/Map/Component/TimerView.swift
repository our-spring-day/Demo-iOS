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
    
    init(_ at: TimerAtwhere) {
        super.init(frame: CGRect.zero)
        whereAt = at
        attribute()
        layout()
        timer()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timer), userInfo: nil, repeats: true)
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
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            
            switch whereAt {
            case .mapView:
                $0.backgroundColor = UIColor(named: "keyColor")
                $0.dropShadow()
            case .rankingView:
                
                $0.backgroundColor = .white
                $0.layer.borderWidth = MannaDemo.convertHeight(value: 1)
                $0.layer.borderColor = UIColor.lightGray.cgColor
                [minuteLabel, secondLabel, colon].forEach { $0.textColor = UIColor(named: "keyColor") }
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
    }
    
    func layout() {
        [minuteLabel, secondLabel, colon].forEach { addSubview($0) }
        minuteLabel.snp.makeConstraints {
            $0.trailing.equalTo(colon.snp.leading).offset(-5)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        secondLabel.snp.makeConstraints {
            $0.leading.equalTo(colon.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        colon.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
