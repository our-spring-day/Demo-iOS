//
//  RankingViewCell.swift
//  MannaDemo
//
//  Created by once on 2020/11/11.
//

import UIKit

class RankingViewCell: UITableViewCell {
    static let rankingCellID = "rangkingCellID"
    
    let profileImage = UIImageView()
    let userName = UILabel()
    let state = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    func setData(data: Ranking) {
        profileImage.do {
            $0.image = data.profileImage
        }
        userName.do {
            $0.text = data.profileName
        }
        state.do {
            $0.text = data.state
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
    }
    
    func layout() {
        [profileImage, userName, state].forEach{ addSubview($0) }
        
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
