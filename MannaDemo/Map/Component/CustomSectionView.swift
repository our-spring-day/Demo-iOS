//
//  CustomSectionView.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/12/08.
//

import UIKit

class CustomSectionView: UIView {
    var sectionTitleLabel = UILabel()
    var sectionbarView = UIView()
    var titleText: String? {
        didSet {
            attribute()
        }
    }
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        titleText = title
        attribute()
        layout()
    }
    
    func attribute() {
        sectionTitleLabel.do {
            $0.text = titleText
            $0.textColor = UIColor(named: "keyColor")
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 13)
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 0
            $0.attributedText = NSMutableAttributedString(string: titleText!, attributes: [NSAttributedString.Key.kern: -0.26, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        }
        sectionbarView.do {
            $0.backgroundColor = UIColor(named: "keyColor")
            $0.alpha = 0.1
        }
    }
    
    func layout() {
        [sectionTitleLabel, sectionbarView].forEach { addSubview($0) }
        
        sectionTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self).offset(MannaDemo.convertWidth(value: 31))
            $0.top.bottom.equalToSuperview()
        }
        sectionbarView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(MannaDemo.convertWidth(value: 305))
            $0.height.equalTo(2)
            $0.trailing.equalTo(self)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
