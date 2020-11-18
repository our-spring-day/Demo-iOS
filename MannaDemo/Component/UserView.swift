//
//  UserView.swift
//  MannaDemo
//
//  Created by once on 2020/10/23.
//

import UIKit

class UserView: UIView {
    init(name: String, frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .brown
        let label = UILabel().then {
            $0.text = name
            $0.textAlignment = .center
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 13)
        }
        self.addSubview(label)
        label.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
