//
//  RankingViewController.swift
//  MannaDemo
//
//  Created by once on 2020/11/11.
//

import UIKit

class RankingViewController: UIViewController {
    lazy var rankginView = UITableView()
    lazy var backgroundView = UIView()
    lazy var prevImage = UIImageView()
    
    let userArr: [Ranking] = [Ranking(profileImage: UIImage(named: "김규리")!, profileName: "김규리", state: "12:40 도착 · 10분 소요", arrival: true),
                              Ranking(profileImage: UIImage(named: "원우석")!, profileName: "원우석", state: "12:50 도착 · 20분 소요", arrival: true),
                              Ranking(profileImage: UIImage(named: "보드리")!, profileName: "보드리", state: "약 10분 남음", arrival: false),
                              Ranking(profileImage: UIImage(named: "윤상원")!, profileName: "윤상원", state: "약 15분 남음", arrival: false),
                              Ranking(profileImage: UIImage(named: "이연재")!, profileName: "이연재", state: "약 20분 남음", arrival: false)]
    
    var arrivalUser: [Ranking] = []
    var notArrivalUser: [Ranking] = []
    lazy var urgentButton = UIButton(frame: CGRect(x: 0, y: 0, width: 79, height: 39))
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        prevImage.do {
            $0.image = UIImage(named: "prev")
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
    }

    func layout() {
        [rankginView, backgroundView, prevImage].forEach { view.addSubview($0) }
        
        rankginView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.topAnchor, constant: MannaDemo.convertHeigt(value: 140)).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        backgroundView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.topAnchor, constant: MannaDemo.convertHeigt(value: 46)).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: MannaDemo.convertWidth(value: 15)).isActive = true
            $0.widthAnchor.constraint(equalToConstant: MannaDemo.convertWidth(value: 45)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: MannaDemo.convertWidth(value: 45)).isActive = true
        }
        prevImage.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        }
    }
    
    func sortedUser() {
        arrivalUser = userArr.filter { $0.arrival }
        notArrivalUser = userArr.filter { !$0.arrival }
    }
    
    @objc func prevButton(_ sender: UITapGestureRecognizer) {
        print("여기가 뒤로가기")
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
                cell.accessoryView = Medal("golden").then {
                    $0.layer.cornerRadius = $0.frame.width / 2
                    $0.clipsToBounds = true
                }
            } else if indexPath.row == 1 {
                cell.accessoryView = Medal("silver")
            } else if indexPath.row == 2 {
                cell.accessoryView = Medal("bronze")
            }
            
            cell.setData(data: arrivalUser[indexPath.row])
        } else if indexPath.section == 1 {
            cell.tapped = { [unowned self] in
                cell.buttonState = false
            }
            cell.setData(data: notArrivalUser[indexPath.row])
        }
        return cell
    }
}
