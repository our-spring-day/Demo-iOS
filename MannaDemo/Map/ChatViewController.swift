//
//  chatViewController.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/03.
//

import UIKit

class ChatViewController: UIViewController {
    var backgroundView = UIView()
    var profileImageView = UIImageView()
    var nameLabel = UILabel()
    var contentLabel = UILabel()
    var paragraphStyle = NSMutableParagraphStyle()
    
    fileprivate func attribute() {
        profileImageView.do {
            $0.image = #imageLiteral(resourceName: "boddle")
        }
        nameLabel.do {
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 14)
            $0.textColor = .black
            paragraphStyle.lineHeightMultiple = 0.99
            $0.attributedText = NSMutableAttributedString(string: "재인", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        }
        contentLabel.do {
            $0.font = UIFont(name: "NotoSansKR-Regular", size: 14)
            $0.textColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            paragraphStyle.lineHeightMultiple = 0.94
            $0.attributedText = NSMutableAttributedString(string: "이번주 토요일 더포도 스터디룸 빌렸어요~\n늦지말고 오세요~👀 1시부터 4시까지 어쩌...", attributes: [NSAttributedString.Key.kern: -0.3, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        
        [backgroundView].forEach {view.addSubview($0)}
        [profileImageView, nameLabel, contentLabel].forEach { backgroundView.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(view).offset(MannaDemo.convertHeigt(value: 26.63))
            $0.width.equalTo(view)
            $0.height.equalTo(view)
            $0.centerX.equalTo(view)
        }
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.equalTo(view).offset(MannaDemo.convertWidth(value: 32.63 * 1.333))
            $0.leading.equalTo(view).offset(MannaDemo.convertWidth(value: 21 * 1.333))
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view).offset(MannaDemo.convertWidth(value: 27 * 1.333))
            $0.leading.equalTo(profileImageView.snp.trailing).offset(MannaDemo.convertWidth(value: 14 * 1.333))
            $0.width.equalTo(MannaDemo.convertWidth(value: 252))
            $0.height.equalTo(MannaDemo.convertWidth(value: 22))
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(MannaDemo.convertWidth(value: 14 * 1.333))
            $0.width.equalTo(MannaDemo.convertWidth(value: 252))
            $0.height.equalTo(MannaDemo.convertWidth(value: 50))
        }
    }
}
