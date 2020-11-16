//
//  RankingViewController.swift
//  MannaDemo
//
//  Created by once on 2020/11/11.
//

import UIKit
import AudioToolbox

protocol RankingView: UIViewController {
    var userList: [String : User] { get set }
}

class RankingViewController: UIViewController, RankingView {
    lazy var rankginView = UITableView()
    lazy var backgroundView = UIView()
    var dismissButton = UIButton()
    var timerView = TimerView(.rankingView)
    var userList: [String : User] = [:]
    var arrivalUser: [User] = []
    var notArrivalUser: [User] = []
    lazy var urgentButton = UIButton(frame: CGRect(x: 0, y: 0, width: 79, height: 39))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortedUser()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(sortedUser), userInfo: nil, repeats: true)
        attribute()
        layout()
    }
    
    func attribute() {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                     action: #selector(prevButton(_:)))
        self.do {
            $0.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//            $0.view.backgroundColor = .white
        }
        backgroundView.do {
            $0.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//            $0.backgroundColor = .white
            $0.addGestureRecognizer(gesture)
        }
        rankginView.do {
            $0.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
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
        arrivalUser = arrivalUser.sorted { $0.remainTime < $1.remainTime }
        notArrivalUser = Array(userList.values).filter { !$0.arrived }
        notArrivalUser = notArrivalUser.sorted { $0.remainTime < $1.remainTime }
        
        rankginView.reloadData()
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
                if let userName = notArrivalUser[indexPath.row].name {
                    let userID = getDeviceToken.getUserDeviceToken(name: userName)
                    MannaAPI.urgeUser(receiveUser: userID)
                }
//                print("유저 이름 : ", notArrivalUser[indexPath.row].name)
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                    cell.buttonState = true
                }
            }
            cell.setData(data: notArrivalUser[indexPath.row])
        }
        return cell
    }

}
