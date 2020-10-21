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
    
    var createMannaButton: UIBarButtonItem?
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    func attribute() {
        createMannaButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMannaButtonAction(_:)))
        self.do {
            $0.title = "Manna List"
            //            $0.navigationController?.navigationBar.prefersLargeTitles = true
            $0.navigationItem.rightBarButtonItem = createMannaButton
        }
        tableView.do {
            $0.register(MannaListTableViewCell.self, forCellReuseIdentifier: MannaListTableViewCell.id)
            $0.delegate = self
            $0.dataSource = self
            $0.refreshControl = refreshControl
        }
        refreshControl.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
    }
    
    func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func createMannaButtonAction(_ sender: UIBarButtonItem) {
        
        let view = CreateMannaViewController()
        self.present(view, animated: true, completion: {
            self.tableView.reloadData()
        })
    }
    
    @objc func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        MannaModel.model.append(Manna(time: "test", name: "테스트스터디명"))
    }
    
}

extension MannaListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MannaModel.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MannaListTableViewCell.id,for: indexPath) as! MannaListTableViewCell
        cell.title.text = MannaModel.model[indexPath.row].name
        return cell
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tableView.reloadData()
    }
}
