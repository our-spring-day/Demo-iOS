//
//  UrgeMessageCollectionViewCell.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/12/09.
//

import UIKit

class UrgeMessageCollectionViewCell: UICollectionViewCell {
    static let cellId = "HotKeywordCellId"
    let keyword = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        keyword.do {
            $0.layer.borderWidth = 1
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = UIColor(named: "keyColor")
            $0.layer.cornerRadius = 10
        }
    }
    
    private func layout() {
        addSubview(keyword)
        keyword.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: topAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }
}
