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
    
    let createMannaButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMannaButtonAction))
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    func attribute() {
        self.do {
            $0.title = "Manna List"
            $0.navigationController?.navigationBar.prefersLargeTitles = true
            $0.navigationItem.rightBarButtonItem = createMannaButton
        }
        tableView.do {
            $0.register(MannaListTableViewCell.self, forCellReuseIdentifier: MannaListTableViewCell.id)
            $0.delegate = self
            $0.dataSource = self
        }
        
    }
    
    func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func createMannaButtonAction() {
        
    }
}

extension MannaListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MannaListTableViewCell.id) as! MannaListTableViewCell
        return cell
    }
    
    
}
