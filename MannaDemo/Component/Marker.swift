//
//  Marker.swift
//  MannaDemo
//
//  Created by once on 2020/10/23.
//

import UIKit

class Marker: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
    }
    
    func attribute() {
        self.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
