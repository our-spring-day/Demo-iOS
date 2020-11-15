//
//  ChatCell.swift
//  MannaDemo
//
//  Created by once on 2020/11/03.
//

import UIKit
import SnapKit

class ChatCell: UITableViewCell {
    static let cellID = "chatCellID"
    let userName = UILabel()
    let userImage = UIImageView()
    var message = UILabel()
    let background = UIView()
    var timeStamp = UILabel()
    
    var leadingConstraints: NSLayoutConstraint!
    var trailingConstraints: NSLayoutConstraint!
    var sendTopConstraints: NSLayoutConstraint!
    var receiveTopConstraints: NSLayoutConstraint!
    var timeStampLeadingConstraints: NSLayoutConstraint!
    var timeStampTrailingConstraints: NSLayoutConstraint!
    
    var chatMessage: ChatMessage! {
        didSet {
            background.backgroundColor = chatMessage.isIncoming == .other ? UIColor.appColor(.receiveMessage) : UIColor.appColor(.sendMessage)
            message.textColor = chatMessage.isIncoming == .other ? .black : .white
            
            message.text = chatMessage.text
            userName.text = chatMessage.isIncoming == .other ? chatMessage.user : ""
            userImage.image = chatMessage.isIncoming == .other ? UIImage(named: chatMessage.user) : nil
            
            if chatMessage.isIncoming == .other {
                leadingConstraints.isActive = true
                trailingConstraints.isActive = false
                timeStampLeadingConstraints.isActive = true
                timeStampTrailingConstraints.isActive = false
                if chatMessage.sendState {
                    receiveTopConstraints.isActive = false
                    sendTopConstraints.isActive = true
                    userImage.isHidden = true
                } else{
                    receiveTopConstraints.isActive = true
                    sendTopConstraints.isActive = false
                }
            } else {
                leadingConstraints.isActive = false
                trailingConstraints.isActive = true
                timeStampLeadingConstraints.isActive = false
                timeStampTrailingConstraints.isActive = true
                receiveTopConstraints.isActive = false
                sendTopConstraints.isActive = true
                userImage.isHidden = true
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImage.isHidden = false
        userName.text?.removeAll()
        message.text?.removeAll()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        attirbute()
        layout()
    }
    
    func configure(chatMessage: ChatMessage) {
        self.message.text = chatMessage.text
        
        switch chatMessage.isIncoming {
        case .me:
            self.userImage.image = nil
            self.userName.text = nil
            self.background.backgroundColor = UIColor.appColor(.sendMessage)
            self.message.textColor = .white
            self.leadingConstraints.isActive = false
            self.trailingConstraints.isActive = true
            self.timeStampLeadingConstraints.isActive = false
            self.timeStampTrailingConstraints.isActive = true
            self.receiveTopConstraints.isActive = false
            self.sendTopConstraints.isActive = true
            self.userImage.isHidden = true
            
        case .other:
            self.userImage.image = UIImage(named: chatMessage.user)
            self.userName.text = chatMessage.user
            self.background.backgroundColor = UIColor.appColor(.receiveMessage)
            self.message.textColor = .black
            self.leadingConstraints.isActive = true
            self.trailingConstraints.isActive = false
            self.timeStampLeadingConstraints.isActive = true
            self.timeStampTrailingConstraints.isActive = false
            if chatMessage.sendState {
                self.receiveTopConstraints.isActive = false
                self.sendTopConstraints.isActive = true
                self.userImage.isHidden = true
            } else{
                self.receiveTopConstraints.isActive = true
                self.sendTopConstraints.isActive = false
            }
        }
        self.setNeedsLayout()
    }
    
    func attirbute() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        userName.do {
            $0.textColor = UIColor.appColor(.chatName)
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        }
        userImage.do {
            $0.layer.cornerRadius = 11
        }
        message.do {
            $0.textColor = .black
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            $0.setLineSpacing(lineSpacing: 10)
        }
        background.do {
            $0.layer.cornerRadius = 9
        }
        timeStamp.do {
            $0.textColor = UIColor.lightGray
            $0.font = UIFont.systemFont(ofSize: 9, weight: .regular)
        }
    }
    func layout() {
        addSubview(userImage)
        addSubview(userName)
        addSubview(background)
        addSubview(message)
        addSubview(timeStamp)
        
        userImage.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 45).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 45).isActive = true
        }
        userName.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            $0.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 5).isActive = true
        }
        message.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
            $0.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        }
        background.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: message.topAnchor, constant: -8).isActive = true
            $0.bottomAnchor.constraint(equalTo: message.bottomAnchor, constant: 8).isActive = true
            $0.leadingAnchor.constraint(equalTo: message.leadingAnchor, constant: -9).isActive = true
            $0.trailingAnchor.constraint(equalTo: message.trailingAnchor, constant: 9).isActive = true
        }
        timeStamp.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.bottomAnchor.constraint(equalTo: background.bottomAnchor).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 9).isActive = true
            $0.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        }
        
        leadingConstraints = message.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 14)
        leadingConstraints.isActive = true
        
        trailingConstraints = message.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraints.isActive = true
        
        receiveTopConstraints = message.topAnchor.constraint(equalTo: userImage.centerYAnchor, constant: 14)
        receiveTopConstraints.isActive = true
        
        sendTopConstraints = message.topAnchor.constraint(equalTo: topAnchor, constant: 15)
        sendTopConstraints.isActive = true
        
        timeStampLeadingConstraints = timeStamp.leadingAnchor.constraint(equalTo: background.trailingAnchor, constant: 5)
        timeStampLeadingConstraints.isActive = true
        
        timeStampTrailingConstraints = timeStamp.trailingAnchor.constraint(equalTo: background.leadingAnchor, constant: -5)
        timeStampTrailingConstraints.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
