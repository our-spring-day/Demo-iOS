//
//  ChatMessageView.swift
//  MannaDemo
//
//  Created by once on 2020/11/04.
//

import UIKit

class ChatMessageView: UIView {
    
    lazy var textInput = UITextField()
    lazy var sendButton = UIButton(frame: CGRect(x: 0, y: 0,
                                                 width: MannaDemo.convertWidth(value: 40),
                                                 height: MannaDemo.convertHeigt(value: 40)))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 1, alpha: 0.8927119007)
        attribute()
        layout()
    }
    
    private func attribute() {
        textInput.do {
            $0.textColor = .black
            $0.attributedPlaceholder = .init(string: "메세지 입력", attributes: [NSAttributedString.Key.foregroundColor: UIColor.appColor(.chatName)])
            $0.layer.cornerRadius = 20
            $0.layer.borderWidth = 1
            $0.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.8549019608, blue: 0.8549019608, alpha: 1)
            $0.backgroundColor = .white
            $0.addLeftPadding()
        }
        sendButton.do {
            $0.setImage(UIImage(named: "finger"), for: .normal)
            $0.imageEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
            $0.backgroundColor = UIColor.appColor(.messageSendButton)
            $0.layer.cornerRadius = $0.frame.size.width/2
            $0.clipsToBounds = true
        }
    }
    
    private func layout() {
        addSubview(textInput)
        addSubview(sendButton)
        textInput.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: topAnchor,
                                    constant: MannaDemo.convertHeigt(value: 5)).isActive = true
            $0.leadingAnchor.constraint(equalTo: leadingAnchor,
                                        constant: MannaDemo.convertWidth(value: 10)).isActive = true
            $0.widthAnchor.constraint(equalToConstant: MannaDemo.convertWidth(value: 298)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: MannaDemo.convertHeigt(value: 40)).isActive = true
        }
        sendButton.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: topAnchor,
                                    constant: MannaDemo.convertHeigt(value: 5)).isActive = true
            $0.leadingAnchor.constraint(equalTo: textInput.trailingAnchor,
                                        constant: MannaDemo.convertWidth(value: 11)).isActive = true
            $0.widthAnchor.constraint(equalToConstant: MannaDemo.convertWidth(value: 40)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: MannaDemo.convertHeigt(value: 40)).isActive = true
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
