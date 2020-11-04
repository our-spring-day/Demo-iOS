//
//  ChatCell.swift
//  MannaDemo
//
//  Created by once on 2020/11/03.
//

import UIKit

class ChatCell: UITableViewCell {
    static let cellID = "chatCellID"
    let userName = UILabel()
    let userImage = UIImageView()
    let message = UILabel()
    let background = UIView()
    
    var leadingConstraints: NSLayoutConstraint!
    var trailingConstraints: NSLayoutConstraint!
    var sendTopConstraints: NSLayoutConstraint!
    var receiveTopConstraints: NSLayoutConstraint!
    
    var chatMessage: ChatMessage! {
        didSet {
            background.backgroundColor = chatMessage.isIncoming ? UIColor.appColor(.receiveMessage) : UIColor.appColor(.sendMessage)
            message.textColor = chatMessage.isIncoming ? .black : .white
            message.text = chatMessage.text
            
            userName.text = chatMessage.isIncoming ? chatMessage.user : ""
            userImage.image = chatMessage.isIncoming ? UIImage(named: chatMessage.user) : nil
            
            if chatMessage.isIncoming {
                leadingConstraints.isActive = true
                trailingConstraints.isActive = false
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
                receiveTopConstraints.isActive = false
                sendTopConstraints.isActive = true
                userImage.isHidden = true
            }
        }
    }
    
    override func prepareForReuse() {
        userImage.isHidden = false
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        attirbute()
        layout()
    }
    
    func attirbute() {
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
        }
        background.do {
            $0.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 1, alpha: 1)
            $0.layer.cornerRadius = 9
        }
    }
    func layout() {
        addSubview(userImage)
        addSubview(userName)
        addSubview(background)
        addSubview(message)
        
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
            $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -21).isActive = true
            $0.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        }
        background.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: message.topAnchor, constant: -8).isActive = true
            $0.bottomAnchor.constraint(equalTo: message.bottomAnchor, constant: 8).isActive = true
            $0.leadingAnchor.constraint(equalTo: message.leadingAnchor, constant: -9).isActive = true
            $0.trailingAnchor.constraint(equalTo: message.trailingAnchor, constant: 8).isActive = true
        }
        
        leadingConstraints = message.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 14)
        leadingConstraints.isActive = true
        
        trailingConstraints = message.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraints.isActive = true
        
        receiveTopConstraints = message.topAnchor.constraint(equalTo: userImage.centerYAnchor, constant: 14)
        receiveTopConstraints.isActive = true
        
        sendTopConstraints = message.topAnchor.constraint(equalTo: topAnchor, constant: 10)
        sendTopConstraints.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
