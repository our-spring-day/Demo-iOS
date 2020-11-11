//
//  GoldenMedal.swift
//  MannaDemo
//
//  Created by once on 2020/11/11.
//

import UIKit

class UrgentButton: UIView {
    lazy var urgentLabel = UILabel()
    lazy var buttonState: Bool = true
//    var buttonState: Bool {
//        didSet {
//            
//        }
//    }
    var timer = Timer()
    init(_ state: Bool) {
        super.init(frame: CGRect(x: 0, y: 0, width: 79, height: 39))
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(stateToggle(timer:)), userInfo: nil, repeats: true)
        setButtonState(state)
        attirbute()
        layout()
    }
    
    func setButtonState(_ state: Bool) {
        if state == true {
            self.backgroundColor = #colorLiteral(red: 0.3529411765, green: 0.4196078431, blue: 1, alpha: 0.1)
            urgentLabel.textColor = #colorLiteral(red: 0.3529411765, green: 0.4196078431, blue: 1, alpha: 1)
        } else {
            self.backgroundColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 0.1)
            urgentLabel.textColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
        }
    }
    
    func attirbute() {
        urgentLabel.do {
            $0.textAlignment = .center
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 13)
            $0.attributedText = NSMutableAttributedString(string: "재촉하기", attributes: [NSAttributedString.Key.kern: -0.13])
        }
    }
    func layout() {
        addSubview(urgentLabel)
        urgentLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
    }
    
    @objc func stateToggle(timer: Timer) {
        print("fdfd")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
