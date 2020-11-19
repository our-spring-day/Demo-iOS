//
//  RankingViewController.swift
//  MannaDemo
//
//  Created by once on 2020/11/11.
//

import UIKit
import AudioToolbox
import NMapsMap

protocol RankingView: UIViewController {
    var userList: [String : User] { get set }
    var locationProfileImageArray: [String : NMFOverlayImage] { get set }
    var disconnectProfileImageArray: [String : NMFOverlayImage] { get set }
}

class RankingViewController: UIViewController, RankingView {
    lazy var rankingView = UITableView()
    var dismissButton = UIButton()
    var timerView = TimerView(.rankingView)
    var userList: [String : User] = [:]
    var arrivalUser: [User] = []
    var notArrivalUser: [User] = []
    lazy var urgentButton = UIButton(frame: CGRect(x: 0, y: 0, width: 79, height: 39))
    lazy var locationProfileImageArray: [String : NMFOverlayImage] = [
        "우석" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["f606564d8371e455"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "연재" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["aed64e8da3a07df4"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "상원" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["8F630481-548D-4B8A-B501-FFD90ADFDBA4"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "재인" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["0954A791-B5BE-4B56-8F25-07554A4D6684"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "효근" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["8D44FAA1-2F87-4702-9DAC-B8B15D949880"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "규리" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["2872483D-9E7B-46D1-A2B8-44832FE3F1AD"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "종찬" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["C65CDF73-8C04-4F76-A26A-AE3400FEC14B"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "용권" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["69751764-A224-4923-9844-C61646743D10"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage())
    ]
    lazy var disconnectProfileImageArray: [String : NMFOverlayImage] = [
        "우석" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["f606564d8371e455"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "연재" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["aed64e8da3a07df4"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "상원" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["8F630481-548D-4B8A-B501-FFD90ADFDBA4"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "재인" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["0954A791-B5BE-4B56-8F25-07554A4D6684"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "효근" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["8D44FAA1-2F87-4702-9DAC-B8B15D949880"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "규리" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["2872483D-9E7B-46D1-A2B8-44832FE3F1AD"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "종찬" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["C65CDF73-8C04-4F76-A26A-AE3400FEC14B"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "용권" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["69751764-A224-4923-9844-C61646743D10"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage())
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        sortedUser()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(sortedUser), userInfo: nil, repeats: true)
        attribute()
        layout()
    }
    
    func attribute() {
        self.do {
            $0.view.backgroundColor = .white
        }
        rankingView.do {
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
        [timerView, rankingView, dismissButton].forEach { view.addSubview($0) }
        
        rankingView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.topAnchor, constant: MannaDemo.convertHeight(value: 140)).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: MannaDemo.convertHeight(value: -140)).isActive = true
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
        
        rankingView.reloadData()
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
        let cell = rankingView.dequeueReusableCell(withIdentifier: RankingViewCell.rankingCellID, for: indexPath) as! RankingViewCell

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
                    MannaAPI.urgeUser(userName: userName)
                }
                Timer.scheduledTimer(withTimeInterval: 180, repeats: false) { _ in
                    cell.buttonState = true
                }
            }
            cell.setData(data: notArrivalUser[indexPath.row])
        }
        return cell
    }

}
