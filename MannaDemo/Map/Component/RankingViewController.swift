//
//  RankingViewController.swift
//  MannaDemo
//
//  Created by once on 2020/11/11.
//

import UIKit

protocol RankingView: UIViewController {
    var userList: [String : User] { get set }
}

class RankingViewController: UIViewController, RankingView {
    lazy var rankginView = UITableView()
    lazy var backgroundView = UIView()
    var dismissButton = UIButton()
    var timerView = TimerView(.rankingView)
    var userList: [String : User] = [:]
//    var userList: [String : User] = [
//        "f606564d8371e455" : User(id: "1", name: "우석", state: false, profileImage: #imageLiteral(resourceName: "우석img"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "우석"), latitude: 0, longitude: 0, remainDistance: 0, ranking: 0, networkValidTime: 0, remainTime: 9999999999, arrived: false),
//        "aed64e8da3a07df4" : User(id: "2", name: "연재", state: false, profileImage: #imageLiteral(resourceName: "disconnect"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "연재"), latitude: 0, longitude: 0, remainDistance: 0, ranking: 0, networkValidTime: 0, remainTime: 9999999999, arrived: false),
//        "8F630481-548D-4B8A-B501-FFD90ADFDBA4" : User(id: "3", name: "상원", state: false, profileImage: #imageLiteral(resourceName: "상원img"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "상원"), latitude: 0, longitude: 0, remainDistance: 100, ranking: 0, networkValidTime: 0, remainTime: 9999999999, arrived: false),
//        "0954A791-B5BE-4B56-8F25-07554A4D6684" : User(id: "4", name: "재인", state: false, profileImage: #imageLiteral(resourceName: "재인img"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "재인"), latitude: 0, longitude: 0, remainDistance: 100, ranking: 0, networkValidTime: 0, remainTime: 9999999999, arrived: false),
//        "8D44FAA1-2F87-4702-9DAC-B8B15D949880" : User(id: "5", name: "효근", state: false, profileImage: #imageLiteral(resourceName: "규리img"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "효근"), latitude: 0, longitude: 0, remainDistance: 100, ranking: 0, networkValidTime: 0, remainTime: 9999999999, arrived: false),
//        "2872483D-9E7B-46D1-A2B8-44832FE3F1AD" : User(id: "6", name: "규리", state: false, profileImage: #imageLiteral(resourceName: "default"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "test"), latitude: 0, longitude: 0, remainDistance: 100, ranking: 0, networkValidTime: 0, remainTime: 9999999999, arrived: false),
//        "C65CDF73-8C04-4F76-A26A-AE3400FEC14B" : User(id: "7", name: "종찬", state: false, profileImage: #imageLiteral(resourceName: "종찬img"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "종찬"), latitude: 0, longitude: 0, remainDistance: 100, ranking: 0, networkValidTime: 0, remainTime: 9999999999, arrived: false),
//        "69751764-A224-4923-9844-C61646743D10" : User(id: "8", name: "용권", state: false, profileImage: #imageLiteral(resourceName: "규리img"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "종찬"), latitude: 0, longitude: 0, remainDistance: 100, ranking: 0, networkValidTime: 0, remainTime: 9999999999, arrived: false)
//    ]
    var arrivalUser: [User] = []
    var notArrivalUser: [User] = []
    lazy var urgentButton = UIButton(frame: CGRect(x: 0, y: 0, width: 79, height: 39))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortedUser()
        print(userList.values)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sortedUser), userInfo: nil, repeats: true)
        sortedUser()
        attribute()
        layout()
    }
    
    func attribute() {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                     action: #selector(prevButton(_:)))
        self.do {
            $0.view.backgroundColor = .white
        }
        backgroundView.do {
            $0.backgroundColor = .white
            $0.addGestureRecognizer(gesture)
        }
        rankginView.do {
            $0.backgroundColor = .white
            $0.register(RankingViewCell.self, forCellReuseIdentifier: RankingViewCell.rankingCellID)
            $0.delegate = self
            $0.dataSource = self
            $0.bounces = false
            $0.separatorStyle = .none
            $0.rowHeight = MannaDemo.convertWidth(value: 70)
        }
        dismissButton.do {
            $0.setImage(#imageLiteral(resourceName: "dismiss"), for: .normal)
            $0.layer.cornerRadius = $0.frame.width / 2
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(prevButton), for: .touchUpInside)
            $0.imageEdgeInsets = UIEdgeInsets(top: MannaDemo.convertHeight(value: 18.02), left: MannaDemo.convertHeight(value: 14.37), bottom: MannaDemo.convertHeight(value: 18.94), right: MannaDemo.convertHeight(value: 14.57))
        }
    }

    func layout() {
        [timerView, rankginView, dismissButton].forEach { view.addSubview($0) }
        
        rankginView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.topAnchor, constant: MannaDemo.convertHeight(value: 140)).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(MannaDemo.convertHeight(value: 46))
            $0.leading.equalToSuperview().offset(15)
            $0.width.height.equalTo(MannaDemo.convertHeight(value: 45))
        }
        timerView.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.centerY.equalTo(dismissButton)
            $0.width.equalTo(MannaDemo.convertWidth(value: 102))
            $0.height.equalTo(MannaDemo.convertHeight(value: 45))
        }
    }
    
    @objc func sortedUser() {
        arrivalUser = Array(userList.values).filter { $0.arrived }
        arrivalUser.sort { $0.remainDistance > $1.remainDistance }
        notArrivalUser = Array(userList.values).filter { !$0.arrived }
        rankginView.reloadData()
        print(userList.values)
    }
    
    @objc func prevButton(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
}

extension RankingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        if section == 0 {
            headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else if section == 1 {
            headerView.backgroundColor = #colorLiteral(red: 0.7066357986, green: 0.7186221, blue: 0.7235718003, alpha: 0.1084653253)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrivalUser.count
        } else if section == 1 {
            return notArrivalUser.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rankginView.dequeueReusableCell(withIdentifier: RankingViewCell.rankingCellID, for: indexPath) as! RankingViewCell

        if indexPath.section == 0 {
            cell.button.isHidden = true
            if indexPath.row == 0{
                cell.medal.medal.image = UIImage(named: "golden")
                cell.medal.backgroundColor = #colorLiteral(red: 1, green: 0.9294117647, blue: 0.5803921569, alpha: 1)

            } else if indexPath.row == 1 {
                cell.medal.medal.image = UIImage(named: "silver")
            } else if indexPath.row == 2 {
                cell.medal.medal.image = UIImage(named: "bronze")
            }
            
            cell.setData(data: arrivalUser[indexPath.row])
        } else if indexPath.section == 1 {
            cell.medal.isHidden = true
            cell.tapped = { [unowned self] in
                cell.buttonState = false
                // 여기에 재촉하는거 함수 구현
                // ->>
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                    cell.buttonState = true
                }
            }
            cell.setData(data: notArrivalUser[indexPath.row])
        }
        return cell
    }

}
