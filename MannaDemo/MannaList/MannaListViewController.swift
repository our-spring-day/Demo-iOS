//
//  MannaListViewController.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/21.
//

import UIKit
import SnapKit
import Then
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON

protocol reloadData {
    func reloadData()
}

class MannaListViewController: UIViewController, reloadData {
    
    var createMannaButton: UIBarButtonItem?
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    
    func reloadData() {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMannaList()
        attribute()
        layout()
    }
    
    func attribute() {
        createMannaButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMannaButtonAction(_:)))
        self.do {
            $0.title = "Manna List"
            $0.navigationController?.navigationBar.prefersLargeTitles = true
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
        view.parentView = self
        self.present(view, animated: true)
    }
    
    @objc func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        
        
        DispatchQueue.global().sync {
            getMannaList()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func getMannaList() {
//        MannaModel.model.removeAll()
        
        guard let deviceID = KeychainWrapper.standard.string(forKey: "device_id") else { return }
        
        let param: Parameters = [
            "device_id" : deviceID,
        ]
        
        let result = AF.request("http://ec2-13-124-151-24.ap-northeast-2.compute.amazonaws.com:8888/manna", parameters: param).responseJSON { response in
            switch response.result {
                case .success(let value):
                    print("\(value)")
                    if let addressList = JSON(value).array {
                        for item in addressList {
                            print(item["manna_name"])
                            print(item["create_timestamp"])
                            MannaModel.model.append(Manna(time: item["create_timestamp"].string!, name: item["manna_name"].string!))
                        }
                    }
                case .failure(let err):
                    print("\(err)")
                }
           }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}
