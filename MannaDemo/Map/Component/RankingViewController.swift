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
    var bottomBar: BottomBar { get set }
    var topBar: TopBar { get set }
    func sortedUser()
    var rankingView: UITableView { get set }
}

class RankingViewController: UIViewController, RankingView {
    
    lazy var rankingView = UITableView()
    var timerView = TimerView(.mapView)
    var userList: [String : User] = [:] {
        didSet {
            sortedUserSelf()
        }
    }
    var arrivalUser: [User] = []
    var notArrivalUser: [User] = []
    var bottomBar = BottomBar()
    var topBar = TopBar()
    
    lazy var urgentButton = UIButton(frame: CGRect(x: 0, y: 0, width: 79, height: 39))
    lazy var locationProfileImageArray: [String : NMFOverlayImage] = [
        "우석" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["f606564d8371e455"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "연재" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["aed64e8da3a07df4"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "상원" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["8F630481-548D-4B8A-B501-FFD90ADFDBA4"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "재인" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["0954A791-B5BE-4B56-8F25-07554A4D6684"]?.name)!, frame: CGRect(x: 0, y: 0, width: 56, height: 56)).asImage()),
        "효근" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["8D44FAA1-2F87-4702-9DAC-B8B15D949880"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "규리" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["2872483D-9E7B-46D1-A2B8-44832FE3F1AD"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "종찬" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["C65CDF73-8C04-4F76-A26A-AE3400FEC14B"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "용권" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["69751764-A224-4923-9844-C61646743D10"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "연재리" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["B8E643AD-E40B-4AF5-8C91-8DBB7412E8B0"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage())
    ]
    lazy var disconnectProfileImageArray: [String : NMFOverlayImage] = [
        "우석" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["f606564d8371e455"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "연재" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["aed64e8da3a07df4"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "상원" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["8F630481-548D-4B8A-B501-FFD90ADFDBA4"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "재인" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["0954A791-B5BE-4B56-8F25-07554A4D6684"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "효근" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["8D44FAA1-2F87-4702-9DAC-B8B15D949880"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "규리" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["2872483D-9E7B-46D1-A2B8-44832FE3F1AD"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "종찬" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["C65CDF73-8C04-4F76-A26A-AE3400FEC14B"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "용권" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["69751764-A224-4923-9844-C61646743D10"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "연재리" : NMFOverlayImage(image: DisconnectProfileVIew(name: (userList["B8E643AD-E40B-4AF5-8C91-8DBB7412E8B0"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortedUser()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(sortedUserSelf), userInfo: nil, repeats: true)
        attribute()
        layout()
    }
    
    func attribute() {
        self.do {
            $0.view.backgroundColor = .white
        }
        
        bottomBar.do {
            $0.backgroundColor = .none
            $0.rankingButton.backgroundColor = UIColor(named: "buttonbackgroundgray")
            $0.chatButton.tag = 22
            $0.rankingButton.tag = 2
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
        topBar.do {
            $0.dismissButton.addTarget(self, action: #selector(didDismissButtonClicked(_:)), for: .touchUpInside)
            $0.dismissButton.tag = 2
        }
    }

    func layout() {
        [rankingView, bottomBar, topBar].forEach { view.addSubview($0) }
        
        rankingView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.topAnchor, constant: MannaDemo.convertHeight(value: 140)).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: bottomBar.topAnchor).isActive = true
        }
        bottomBar.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.snp.bottom).offset(-90)
        }
        topBar.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view)
            $0.height.equalTo(MannaDemo.convertWidth(value: 94))
        }
    }
    
    @objc func sortedUserSelf() {
        arrivalUser = Array(userList.values).filter { $0.arrived }
        arrivalUser = arrivalUser.sorted { $0.remainTime < $1.remainTime }
        notArrivalUser = Array(userList.values).filter { !$0.arrived }
        notArrivalUser = notArrivalUser.sorted { $0.remainTime < $1.remainTime }
        rankingView.reloadData()
    }
    
    func sortedUser() {
        arrivalUser = Array(userList.values).filter { $0.arrived }
        arrivalUser = arrivalUser.sorted { $0.remainTime < $1.remainTime }
        notArrivalUser = Array(userList.values).filter { !$0.arrived }
        notArrivalUser = notArrivalUser.sorted { $0.remainTime < $1.remainTime }
        rankingView.reloadData()
    }
    
    @objc func didDismissButtonClicked(_ sender: UITapGestureRecognizer) {
//        rankingView.alpha = 1
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
