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
    var pushChat: UIBarButtonItem?
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    func reloadData() {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMannaList(completion: {
            self.tableView.reloadData()
        })
        attribute()
        layout()
    }
    
    func attribute() {
        createMannaButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMannaButtonAction(_:)))
        pushChat = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(pushChatView))
        self.do {
            $0.title = "Test"
            $0.navigationController?.navigationBar.prefersLargeTitles = true
            $0.navigationItem.rightBarButtonItems = [createMannaButton!, pushChat!]
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
    
    @objc func pushChatView() {
        let view = ChattingViewController()
        navigationController?.pushViewController(view, animated: true)
    }
    
    @objc func createMannaButtonAction(_ sender: UIBarButtonItem) {
        
        let view = CreateMannaViewController()
        view.parentView = self
        self.present(view, animated: true)
    }
    
    @objc func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        
        self.getMannaList(completion: {
            self.tableView.reloadData()
        })
    }
    
    func getMannaList(completion: @escaping () -> Void) {
        MannaModel.model.removeAll()
        guard let deviceID = KeychainWrapper.standard.string(forKey: "device_id") else { return }
        let param: Parameters = [
            "device_id" : deviceID,
        ]
        
        let result = AF.request("https://manna.duckdns.org:18888/manna?deviceToken=\(deviceID)", parameters: param).responseJSON { response in

            switch response.result {
            case .success(let value):
                JSON(value).forEach { (_,data) in
                    let item = NewManna(mannaname: data["mannaName"].string!,
                             createTimestamp: data["createTimestamp"].int!,
                             uuid: data["uuid"].string!)
                    MannaModel.newModel.append(item)
                }
                completion()
                break
            case .failure(let error):
                break
            }
        }
    }
}


extension MannaListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MannaModel.newModel.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MannaListTableViewCell.id,for: indexPath) as! MannaListTableViewCell
        if MannaModel.newModel.count > 0 {
            cell.title.text = MannaModel.newModel[indexPath.row].mannaname
        }
        return cell
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var view = MapViewController()
        var subChatView = ChattingViewController()
        var subRankingView = RankingViewController()
        
        view.chattingViewController = subChatView
        view.rankingViewController = subRankingView
        
        view.rankingViewController?.userList = UserModel.userList
        view.meetInfo  = MannaModel.newModel[indexPath.row]
        DispatchQueue.global().async {
            MannaAPI.getChat(mannaID: MannaModel.newModel[indexPath.row].uuid) { result in
                print(result)
                subChatView.chatMessage = result
                view.chattingViewController = subChatView
            }
        }
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
}
