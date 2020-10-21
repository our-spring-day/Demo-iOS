//
//  MannaListViewController.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/21.
//

import UIKit
import SnapKit
import Then

class MannaListViewController: UIViewController {
    
    var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
    let createMannaButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMannaButtonAction))
    let navItem = UINavigationItem(title: "Manna List")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    func attribute() {
        self.do {
            $0.title = "테스트"
        }
        navItem.do {
            $0.rightBarButtonItem = createMannaButton
        }
        navigationBar.do {
            $0.prefersLargeTitles = true
            $0.setItems([navItem], animated: true)
        }
    }
    
    func layout() {
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func createMannaButtonAction() {
        
    }
}
