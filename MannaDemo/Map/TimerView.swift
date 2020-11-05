//
//  TimerView.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/05.
//

import UIKit

class TimerView: UIView {
    var hourLabel = UILabel()
    var minuteLabel = UILabel()
    var secondLabel = UILabel()
    var colon1 = UILabel()
    var conlon2 = UILabel()
    
    init() {
        super.init(frame: CGRect.zero)
        attribute()
        layout()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timer), userInfo: nil, repeats: true)
    }
    
    @objc func timer() {
        let hourFormatter = DateFormatter()
        let miniuteFormatter = DateFormatter()
        let secondFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        miniuteFormatter.dateFormat = "mm"
        secondFormatter.dateFormat = "ss"
        
        let hour = hourFormatter.string(from: Date())
        let minute = miniuteFormatter.string(from: Date())
        let second = secondFormatter.string(from: Date())
        
        hourLabel.text = "\((Int(hour)!) - Int(hour)!)"
        minuteLabel.text = "\(20 - Int(minute)!)"
        secondLabel.text = "\(60 - Int(second)!)"
        
        if (20 - Int(minute)!) > 10 && (20 - Int(minute)!) < 20 {
            self.backgroundColor = UIColor(named: "20minute")
        } else if (20 - Int(minute)!) <= 10 {
            self.backgroundColor = UIColor(named: "10minute")
        } else {
            self.backgroundColor = UIColor(named: "keyColor")
        }
    }

    
    func attribute() {
        self.do {
            $0.backgroundColor = UIColor(named: "keyColor")
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            $0.dropShadow()
        }
        [hourLabel, minuteLabel, secondLabel].forEach {
            $0.do {
                $0.font = UIFont(name: "SFProDisplay-Medium", size: 17)
                $0.textAlignment = .center
                $0.textColor = .white
            }
        }
        [colon1,conlon2].forEach {
            $0.text = ":"
            $0.textAlignment = .center
            $0.textColor = .white
        }
    }
    
    func layout() {
        [hourLabel, minuteLabel, secondLabel, colon1, conlon2].forEach { addSubview($0) }
        
        hourLabel.snp.makeConstraints {
            $0.trailing.equalTo(minuteLabel.snp.leading).offset(-5)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        minuteLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        secondLabel.snp.makeConstraints {
            $0.leading.equalTo(minuteLabel.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        colon1.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.leading.equalTo(hourLabel.snp.trailing)
            $0.trailing.equalTo(minuteLabel.snp.leading)
        }
        conlon2.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.leading.equalTo(minuteLabel.snp.trailing)
            $0.trailing.equalTo(secondLabel.snp.leading)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
