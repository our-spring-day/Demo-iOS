//
//  GoldenMedal.swift
//  MannaDemo
//
//  Created by once on 2020/11/11.
//

import UIKit

class Medal: UIView {
    var medalState: String = ""
    lazy var medal = UIImageView()
    init(_ medal: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        self.backgroundColor = #colorLiteral(red: 1, green: 0.9294117647, blue: 0.5803921569, alpha: 1)
        setMedal(medal: medal)
        layout()
    }
    
    func setMedal(medal: String) {
        if medal == "golden" {
            self.medal.image = UIImage(named: medal)
        } else if medal == "silver" {
            self.medal.image = UIImage(named: medal)
        } else if medal == "bronze" {
            self.medal.image = UIImage(named: medal)
        }
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
