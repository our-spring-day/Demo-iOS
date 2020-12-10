//
//  UrgeToastMessage.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/12/10.
//

import UIKit

class UrgeToastMessage: UIView {
    
    var messageLabel = UILabel()
    var to = "" {
        didSet {
            attribute()
        }
    }
    
    init(frame: CGRect, to: String) {
        super.init(frame: frame)
        self.to = to
        layout()
    }
    
    func attribute() {
        self.do {
            $0.layer.cornerRadius = 6
            $0.layer.masksToBounds = true
            $0.backgroundColor = .black
            $0.alpha = 0.7
        }
        messageLabel.do {
            $0.font = UIFont(name: "NotoSansKR-Regular", size: 14)
            $0.textColor = .white
            let paragraphStyle = NSMutableParagraphStyle()
            $0.textAlignment = .center
            $0.attributedText = NSMutableAttributedString(string: "\(to)님에게 재촉메시지를 보냈습니다.", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        }
    }
    
    func layout() {
        [messageLabel].forEach { addSubview($0) }
        
        messageLabel.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
