//
//  UrgeMessageCollectionViewCell.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/12/09.
//

import UIKit

class UrgeMessageCollectionViewCell: UICollectionViewCell {
    static let cellId = "HotKeywordCellId"
    let urgeMessageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        urgeMessageLabel.do {
            $0.textColor = UIColor(red: 0.302, green: 0.302, blue: 0.302, alpha: 1)
            $0.font = UIFont(name: "NotoSansKR-Medium", size: 14)
            $0.attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.kern: -0.14])
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            $0.backgroundColor = UIColor(named: "urgemessagebackground")
        }
    }
    
    private func layout() {
//        contentView.addSubview(urgeMessageLabel)
        addSubview(urgeMessageLabel)
        urgeMessageLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: topAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }
}
