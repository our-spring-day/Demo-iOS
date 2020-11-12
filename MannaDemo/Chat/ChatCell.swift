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
    var timeStamp = UILabel()
    
    var leadingConstraints: NSLayoutConstraint!
    var trailingConstraints: NSLayoutConstraint!
    var sendTopConstraints: NSLayoutConstraint!
    var receiveTopConstraints: NSLayoutConstraint!
    var timeStampLeadingConstraints: NSLayoutConstraint!
    var timeStampTrailingConstraints: NSLayoutConstraint!
    
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
            $0.text = "오후 12:47"
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
            $0.widthAnchor.constraint(equalToConstant: $0.intrinsicContentSize.width + 20).isActive = true
        }
        
        leadingConstraints = message.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 14)
        leadingConstraints.isActive = true
        
        trailingConstraints = message.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraints.isActive = true
        
        receiveTopConstraints = message.topAnchor.constraint(equalTo: userImage.centerYAnchor, constant: 14)
        receiveTopConstraints.isActive = true
        
        sendTopConstraints = message.topAnchor.constraint(equalTo: topAnchor, constant: 15)
        sendTopConstraints.isActive = true
        
        timeStampLeadingConstraints = timeStamp.leadingAnchor.constraint(equalTo: message.trailingAnchor, constant: 15)
        timeStampLeadingConstraints.isActive = true
        
        timeStampTrailingConstraints = timeStamp.trailingAnchor.constraint(equalTo: message.leadingAnchor, constant: -5)
        timeStampTrailingConstraints.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
