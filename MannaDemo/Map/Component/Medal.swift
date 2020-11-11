//
//  GoldenMedal.swift
//  MannaDemo
//
//  Created by once on 2020/11/11.
//

import UIKit
import Then

class Medal: UIView {
    lazy var medal = UIImageView().then {
        $0.layer.cornerRadius = $0.frame.width / 2
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    func layout() {
        addSubview(medal)
        medal.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: MannaDemo.convertWidth(value: 24)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: MannaDemo.convertWidth(value: 24)).isActive = true
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
