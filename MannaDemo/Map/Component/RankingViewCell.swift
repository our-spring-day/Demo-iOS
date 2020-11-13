//
//  RankingViewCell.swift
//  MannaDemo
//
//  Created by once on 2020/11/11.
//

import UIKit

class RankingViewCell: UITableViewCell {
    static let rankingCellID = "rankingCellID"
    var tapped: (() -> ())?
    var buttonState: Bool = true {
        didSet {
            button.isUserInteractionEnabled = buttonState ? true : false
            button.backgroundColor = buttonState ? UIColor.appColor(.urgentOn) : UIColor.appColor(.urgentOff)
            if buttonState == true {
                button.setTitleColor(#colorLiteral(red: 0.3529411765, green: 0.4196078431, blue: 1, alpha: 1), for: .normal)
            } else {
                button.setTitleColor(#colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1), for: .normal)
            }
        }
    }
    lazy var profileImage = UIImageView()
    lazy var userName = UILabel()
    lazy var state = UILabel()
    lazy var medal = Medal(frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 42), height: MannaDemo.convertWidth(value: 42)))
    lazy var button = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        attribute()
        layout()
    }
    
    func setData(data: User) {
        profileImage.do {
            $0.image = data.profileImage
        }
        userName.do {
            $0.text = data.name
        }
        state.do {
            $0.text = data.state ? "\(data.remainTime)" : "연결끊김(tempMessage)"
//            $0.text = "\(data.remainTime)"
        }
        medal.do {
            $0.layer.cornerRadius = $0.frame.width / 2
            $0.clipsToBounds = true
        }
    }
    
    func attribute() {
        self.do {
            $0.backgroundColor = .white
        }
        profileImage.do {
            $0.contentMode = .scaleAspectFill
            $0.frame.size.width = MannaDemo.convertWidth(value: 58)
            $0.frame.size.height = MannaDemo.convertWidth(value: 58)
            $0.layer.cornerRadius = $0.frame.width / 2
            $0.clipsToBounds = true
        }
        userName.do {
            $0.textColor = #colorLiteral(red: 0.7098039216, green: 0.7098039216, blue: 0.7098039216, alpha: 1)
            $0.font = UIFont(name: "NotoSansKR-Medium", size: 13)
        }
        state.do {
            $0.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
            $0.font = UIFont(name: "NotoSansKR-Medium", size: 14)
        }
        button.do {
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.backgroundColor = UIColor.appColor(.urgentOn)
            $0.setTitle("재촉하기", for: .normal)
            $0.setTitleColor(#colorLiteral(red: 0.3529411765, green: 0.4196078431, blue: 1, alpha: 1), for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 13)
            $0.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        }
    }
    
    func layout() {
        [profileImage, userName, state, medal, button].forEach{ contentView.addSubview($0) }
        
        profileImage.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: MannaDemo.convertWidth(value: 24)).isActive = true
            $0.widthAnchor.constraint(equalToConstant: MannaDemo.convertWidth(value: 58)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: MannaDemo.convertWidth(value: 58)).isActive = true
        }
        userName.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 10).isActive = true
            $0.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: MannaDemo.convertWidth(value: 15)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 19).isActive = true
        }
        state.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 3).isActive = true
            $0.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: MannaDemo.convertWidth(value: 15)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 19).isActive = true
        }
        button.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 79).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 39).isActive = true
        }
        medal.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            $0.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            
            $0.widthAnchor.constraint(equalToConstant: MannaDemo.convertWidth(value: 42)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: MannaDemo.convertWidth(value: 42)).isActive = true
        }
    }
    
    @objc func tapButton(_ sender: UIButton) {
        tapped?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
