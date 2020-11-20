//
//  InputBar.swift
//  MannaDemo
//
//  Created by once on 2020/11/18.
//

import UIKit
import UITextView_Placeholder

class InputBar: UIView {
    let textView = UITextView().then {
        $0.textColor = .black
        $0.isEditable = true
        $0.font = UIFont(name: "NotoSansKR-Regular", size: 15)
        $0.showsVerticalScrollIndicator = false
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.8549019608, blue: 0.8549019608, alpha: 1)
        $0.backgroundColor = .white
        $0.placeholder = "메세지 작성"
        $0.placeholderColor = UIColor.lightGray
        $0.textContainerInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    }
    let sendButton = UIButton(frame: CGRect(x: 0,
                                            y: 0,
                                            width: MannaDemo.convertWidth(value: 17),
                                            height: MannaDemo.convertHeight(value: 17)))
        .then {
            $0.setImage(UIImage(named: "good"), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
            $0.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.textView)
        self.addSubview(self.sendButton)
        
        self.textView.snp.makeConstraints {
            $0.top.equalTo(5)
            $0.leading.equalTo(13)
            $0.bottom.equalTo(-7)
            $0.width.equalTo(300)
            $0.height.equalTo(40)
        }
        self.sendButton.snp.makeConstraints {
            $0.top.equalTo(5)
            $0.bottom.equalTo(-7)
            $0.leading.equalTo(textView.snp.trailing).offset(8)
            $0.trailing.equalTo(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
