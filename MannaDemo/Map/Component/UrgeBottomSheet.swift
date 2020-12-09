//
//  File.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/12/08.
//

import UIKit

class UrgeBottomSheet: UIView {
    var titleLabel = UILabel()
    var dismissButton = UIButton()
    let collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    func attribute() {
        self.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
        }
        titleLabel.do {
            $0.textColor = UIColor(red: 0.383, green: 0.383, blue: 0.383, alpha: 1)
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.attributedText = NSMutableAttributedString(string: "재촉메시지 보내기", attributes: [NSAttributedString.Key.kern: -0.16])
        }
        dismissButton.do {
            $0.backgroundColor = .white
            $0.setImage(UIImage(named: "ranking_dismiss"), for: .normal)
        }
        collectionView.do {
            $0.register(UrgeMessageCollectionViewCell.self, forCellWithReuseIdentifier: UrgeMessageCollectionViewCell.cellId)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        attribute()
        [titleLabel, dismissButton, collectionView].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalTo(self).offset(22)
            $0.width.equalTo(130)
            $0.height.equalTo(23)
        }
        dismissButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalTo(self).offset(-28.49)
            $0.width.height.equalTo(25.4982)
        }
        collectionView.snp.makeConstraints {
            $0.leading.equalTo(self).offset(MannaDemo.convertWidth(value: 20))
            $0.top.equalTo(titleLabel.snp.bottom).offset(MannaDemo.convertHeight(value: 25))
            $0.height.equalTo(200)
            $0.trailing.equalTo(self.snp.trailing)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
