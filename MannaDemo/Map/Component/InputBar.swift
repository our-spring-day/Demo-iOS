//
//  InputBar.swift
//  MannaDemo
//
//  Created by once on 2020/11/18.
//

import UIKit

class InputBar: UIView {
    let textView = UITextView().then {
        $0.textColor = .black
        $0.isEditable = true
        $0.showsVerticalScrollIndicator = false
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.8549019608, blue: 0.8549019608, alpha: 1)
        $0.backgroundColor = .white
    }
    let sendButton = UIButton(frame: CGRect(x: 0,
                                            y: 0,
                                            width: MannaDemo.convertWidth(value: 17),
                                            height: MannaDemo.convertHeight(value: 17)))
        .then {
            $0.setImage(UIImage(named: "good"), for: .normal)
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.textView)
        self.addSubview(self.sendButton)
        
        self.textView.snp.makeConstraints {
            $0.top.equalTo(5)
            $0.trailing.equalTo(self.sendButton.snp.leading).offset(-7)
            $0.leading.equalTo(10)
            $0.bottom.equalTo(-7)
        }
        self.sendButton.snp.makeConstraints {
            $0.top.equalTo(5)
            $0.bottom.equalTo(-7)
            $0.right.equalTo(-7)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
