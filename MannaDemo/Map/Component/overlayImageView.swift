//
//  overlayImageView.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/18.
//

import UIKit

class defaultOverlayView: UIView {
    var backgroundCircle = UIView()
    var coreCircle = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    func attribute() {
        backgroundCircle.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = MannaDemo.convertWidth(value: 5)
            $0.layer.masksToBounds = false
        }
        coreCircle.do {
            $0.backgroundColor = UIColor(named: "overlaycolor")
            $0.layer.cornerRadius = MannaDemo.convertWidth(value: 3.5)
            $0.layer.masksToBounds = false
        }
    }
    
    func layout() {
        [backgroundCircle, coreCircle].forEach { self.addSubview($0) }
        
        backgroundCircle.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(MannaDemo.convertWidth(value: 10))
        }
        coreCircle.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self)
            $0.width.height.equalTo(MannaDemo.convertWidth(value: 7))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class compassOverLayView: UIView {
    
    lazy var backgroundCircle = UIView()
    lazy var coreCircle = UIView()
    lazy var coreVector = UIImageView()
    lazy var backgroundVector = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    func attribute() {
        backgroundCircle.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = MannaDemo.convertWidth(value: 5)
            $0.layer.masksToBounds = false
        }
        coreCircle.do {
            $0.backgroundColor = UIColor(named: "overlaycolor")
            $0.layer.cornerRadius = MannaDemo.convertWidth(value: 3.5)
            $0.layer.masksToBounds = false
        }
        coreVector.do {
            $0.image = #imageLiteral(resourceName: "vector1")
        }
        backgroundVector.do {
            $0.image = #imageLiteral(resourceName: "vector2")
        }
    }
    
    func layout() {
        [backgroundVector, coreVector, backgroundCircle, coreCircle].forEach { self.addSubview($0) }
        
        backgroundVector.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self)
            $0.bottom.equalTo(backgroundCircle.snp.centerY)
        }
        coreVector.snp.makeConstraints {
            $0.bottom.equalTo(backgroundCircle.snp.centerY)
            $0.centerX.equalTo(self)
            $0.leading.equalTo(coreCircle).offset(0.75)
            $0.trailing.equalTo(coreCircle).offset(-0.75)
            $0.height.equalTo(9.5)
        }
        backgroundCircle.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(MannaDemo.convertWidth(value: 10))
        }
        coreCircle.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self)
            $0.width.height.equalTo(MannaDemo.convertWidth(value: 7))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
