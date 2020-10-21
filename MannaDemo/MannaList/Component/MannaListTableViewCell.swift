//
//  MannaListTableViewCell.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/21.
//

import UIKit


class MannaListTableViewCell: UITableViewCell {
    
    static let id = "MAnnaListTableViewCell"
    var title = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        addSubview(title)
        
        title.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
