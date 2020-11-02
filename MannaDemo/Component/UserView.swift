//
//  UserView.swift
//  MannaDemo
//
//  Created by once on 2020/10/23.
//

import UIKit

class UserView: UIView {
    let title = UILabel()
    var text: String
    
    init(text: String) {
        self.text = text
        super.init(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        attribute()
        layout()
        setNeedsDisplay()
    }
    
    func attribute() {
        backgroundColor = .darkGray
        title.do {
            $0.text = self.text
            $0.textAlignment = .center
            $0.textColor = .white
//            $0.font = $0.font.withSize(20)
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
    
    func layout() {
        self.addSubview(title)
        title.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
