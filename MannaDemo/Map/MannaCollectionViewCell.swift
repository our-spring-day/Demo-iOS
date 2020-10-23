//
//  MannaCollectionViewCell.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/23.
//

import UIKit

class MannaCollectionViewCell: UICollectionViewCell {
    static  let identifier = "cell"
    
    var profileImage = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    func attribute() {
        profileImage.do {
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill
        }
    }
    
    func layout() {
        addSubview(self.profileImage)
        
        profileImage.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
