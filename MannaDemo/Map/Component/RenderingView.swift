//
//  overlayImageView.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/18.
//

import UIKit

class DefaultOverlayView: UIView {
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

class CompassOverLayView: UIView {
    
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

class DisconnectProfileVIew: UIView {
    var backgroundView = UIImageView()
    var triangleVIew = UIImageView()
    var userName = ""
    var zzzImage = UIImageView()
    
    init(name: String,  frame: CGRect) {
        super.init(frame: frame)
        userName = name
        attribute()
        layout()
    }
    
    func attribute() {
        self.do {
            $0.alpha = 0.3
        }
        backgroundView.do {
            $0.image = UIImage(named: "\(userName)")
            $0.layer.borderWidth = MannaDemo.convertWidth(value: 3)
            $0.layer.borderColor = UIColor(named: "bordercolor")?.cgColor
            $0.layer.cornerRadius = MannaDemo.convertWidth(value: 24)
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
        }
        triangleVIew.do {
            $0.image = #imageLiteral(resourceName: "triangle")
        }
        zzzImage.do {
            $0.image = #imageLiteral(resourceName: "용권1")
        }
    }
    
    func layout() {
        [triangleVIew, backgroundView, zzzImage].forEach { self.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.width.height.equalTo(MannaDemo.convertWidth(value: 56))
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(MannaDemo.convertWidth(value: 3.3))
            $0.trailing.equalToSuperview().offset(MannaDemo.convertWidth(value: -3.3))
        }
        triangleVIew.snp.makeConstraints {
//            $0.bottom.equalToSuperview().offset(MannaDemo.convertWidth(value: -1.5))
            $0.top.equalTo(backgroundView.snp.bottom).offset(-MannaDemo.convertWidth(value: 5))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(MannaDemo.convertWidth(value: 20))
            $0.height.equalTo(MannaDemo.convertWidth(value: 10.44))
        }
        zzzImage.snp.makeConstraints {
            $0.width.equalTo(MannaDemo.convertWidth(value: 30))
            $0.height.equalTo(MannaDemo.convertHeight(value: 30))
            $0.top.trailing.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LocationProfileImageVIew: UIView {
    
    var backgroundView = UIImageView()
    var triangleVIew = UIImageView()
    var userName = ""
    init(name: String,  frame: CGRect) {
        super.init(frame: frame)
        userName = name
        attribute()
        layout()
    }
    
    func attribute() {
        backgroundView.do {
            $0.image = UIImage(named: "\(userName)")
            $0.layer.borderWidth = MannaDemo.convertWidth(value: 3)
            $0.layer.borderColor = UIColor(named: "bordercolor")?.cgColor
            $0.layer.cornerRadius = MannaDemo.convertWidth(value: 24)
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
        }
        triangleVIew.do {
            $0.image = #imageLiteral(resourceName: "triangle")
        }
    }
    
    func layout() {
        [triangleVIew, backgroundView].forEach { self.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.width.height.equalTo(MannaDemo.convertWidth(value: 56))
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(MannaDemo.convertWidth(value: 3.3))
            $0.trailing.equalToSuperview().offset(MannaDemo.convertWidth(value: -3.3))
        }
        triangleVIew.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.bottom).offset(-MannaDemo.convertWidth(value: 5))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(MannaDemo.convertWidth(value: 20))
            $0.height.equalTo(MannaDemo.convertWidth(value: 10.44))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatProfileImageView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
