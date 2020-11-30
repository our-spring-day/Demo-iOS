//
//  TopBar.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/19.
//

import UIKit

class TopBar: UIView {
    var title = UILabel()
    var dismissButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    func attribute() {
        title.do {
            $0.textColor = UIColor(red: 0.254, green: 0.254, blue: 0.254, alpha: 1)
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 22)
            $0.attributedText = NSMutableAttributedString(string: "도착 정보", attributes: [NSAttributedString.Key.kern: -0.44])
        }
        dismissButton.do {
            $0.setImage(#imageLiteral(resourceName: "dismiss"), for: .normal)
            $0.layer.cornerRadius = $0.frame.width / 2
            $0.clipsToBounds = true
            $0.imageEdgeInsets = UIEdgeInsets(top: MannaDemo.convertHeight(value: 18.02), left: MannaDemo.convertHeight(value: 14.37), bottom: MannaDemo.convertHeight(value: 18.94), right: MannaDemo.convertHeight(value: 14.57))
        }
    }
    
    func layout() {
        [title, dismissButton].forEach { addSubview($0) }
        
        title.snp.makeConstraints {
            $0.leading.equalTo(self).offset(20)
            $0.top.equalTo(self).offset(51.25)
            
            $0.width.equalTo(200)
            $0.height.equalTo(MannaDemo.convertWidth(value: 33))
        }
        dismissButton.snp.makeConstraints {
            $0.centerY.equalTo(title)
            $0.trailing.equalTo(self).offset(-MannaDemo.convertWidth(value: 31))
            $0.width.height.equalTo(MannaDemo.convertHeight(value: 45))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
