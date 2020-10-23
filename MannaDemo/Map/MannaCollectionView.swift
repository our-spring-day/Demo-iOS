//
//  MannaCollectionView.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/23.
//

import UIKit


class MannaCollectionView: UICollectionView {
    let layoutValue: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    init(frame: CGRect) {
        super.init(frame: frame,collectionViewLayout: layoutValue)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        self.do {
            $0.backgroundColor = .gray
            $0.alpha = 0.7
            $0.register(MannaCollectionViewCell.self, forCellWithReuseIdentifier: MannaCollectionViewCell.identifier)
            $0.isPagingEnabled = false
            $0.isScrollEnabled = false
            $0.showsHorizontalScrollIndicator = false
        }
        layoutValue.do {
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.minimumLineSpacing = 10
            $0.minimumInteritemSpacing = 10
            $0.itemSize = CGSize(width: 50, height: 50)
            $0.scrollDirection = .vertical
        }
        
    }
    
    func layout() {
        self.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width * 0.8)
            $0.height.equalTo(400)
            $0.centerX.equalTo(self.snp.centerX)
        }
    }
}
