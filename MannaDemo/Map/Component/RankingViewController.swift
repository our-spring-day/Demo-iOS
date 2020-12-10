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
    var topBar: TopBar { get set }
    func sortedUser()
    var rankingView: UITableView { get set }
    var parentView: BottomBarHidden? { get set }
}

class RankingViewController: UIViewController, RankingView {
    var parentView: BottomBarHidden?
    lazy var rankingView = UITableView(frame: CGRect.zero, style: .grouped)
    let arrivedSectionHeaderView = CustomSectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 13), title: "도착")
    let startSectionHeaderView = CustomSectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20), title: "출발")
    let notstartSectionHeaderView = CustomSectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 13), title: "준비")
    var userList: [String : User] = [:] {
        didSet {
            sortedUserSelf()
        }
    }
    lazy var backgroundViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewDidTap(_: )))
    var urgeBottomSheetBackgroundView = UIView()
    var arrivalUser: [User] = []
    var notArrivalUser: [User] = []
    var notStartUser: [User] = []
    var topBar = TopBar()
    var bottomSheet = UrgeBottomSheet()
    lazy var urgentButton = UIButton(frame: CGRect(x: 0, y: 0, width: 79, height: 39))
    lazy var locationProfileImageArray: [String : NMFOverlayImage] = [
        "우석" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["f606564d8371e455"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "연재" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["aed64e8da3a07df4"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "상원" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["8F630481-548D-4B8A-B501-FFD90ADFDBA4"]?.name)!, frame: CGRect(x: 0, y: 0, width: MannaDemo.convertWidth(value: 56), height: MannaDemo.convertWidth(value: 62.61))).asImage()),
        "재인" : NMFOverlayImage(image: LocationProfileImageVIew(name: (userList["0954A791-B5BE-4B56-8F25-07554A4D6684"]?.name)!, frame: CGRect(x: 0, y: 0, width: 56, height: 56
        )).asImage()),
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
    
    var urgeMessageList: [String] = [
        "👀 난 니가 어딘지 안다",
        "💗 보고싶어 빨리와",
        "🐢 기어오는구나",
        "💩 외않와?",
        "🤖 삐빅 - 인내심이 바닥났습니다",
        "😌 다시 집에 가면 되나",
        "🤯 아직도 거기냐",
        "🥶 추워...",
        "🔥 빨리와",
        "🥱 이젠 정말 질린다",
        "🥳 늦으면 우리만의 추억 백만개",
        "🤥 입만 열면 구라인 당신...",
        "😜 늦으면 우리끼리 셀카 오조오억장",
        "😇 오~내일 오는건가",
        "😊 안 뛰고 뭐하냐",
        "😬 저.기.요."
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
            $0.title.text = "도착 예상 시간"
        }
        urgeBottomSheetBackgroundView.do {
            $0.backgroundColor = .black
            $0.alpha = 0.3
            $0.isHidden = true
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(backgroundViewTapGesture)
        }
        bottomSheet.do {
            $0.isHidden = true
            $0.dismissButton.addTarget(self, action: #selector(bottomSheetDown), for: .touchUpInside)
            $0.collectionView.delegate = self
            $0.collectionView.dataSource = self
        }
        
    }
    
    func layout() {
        [rankingView, topBar, urgeBottomSheetBackgroundView, bottomSheet].forEach { view.addSubview($0) }
        
        rankingView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        topBar.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view)
            $0.height.equalTo(MannaDemo.convertWidth(value: 94))
        }
        bottomSheet.snp.makeConstraints {
            $0.leading.trailing.equalTo(view)
            $0.top.equalTo(view.snp.bottom)
            $0.height.equalTo(MannaDemo.convertHeight(value: 330))
        }
        urgeBottomSheetBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
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
    
    @objc func backgroundViewDidTap(_ sender: UIView) {
        bottomSheetDown()
    }
    
    func bottomSheetUp() {
        parentView?.bottomBarHidden()
        urgeBottomSheetBackgroundView.isHidden = false
        bottomSheet.isHidden = false
        UIView.animate(withDuration: 0.2) {
            
            self.bottomSheet.transform = CGAffineTransform(translationX: 0, y: -MannaDemo.convertHeight(value: 330))
            self.urgeBottomSheetBackgroundView.alpha = 0.3
        } completion: { _ in
            
        }
    }
    
    @objc func bottomSheetDown() {
        self.parentView?.bottomBarAppear()
        UIView.animate(withDuration: 0.2) { [self] in
            self.parentView?.bottomBar.alpha = 1
            self.bottomSheet.transform = CGAffineTransform(translationX: 0, y: 0)
            self.urgeBottomSheetBackgroundView.alpha = 0
        } completion: { _ in
            self.urgeBottomSheetBackgroundView.isHidden = true
            self.bottomSheet.isHidden = true
        }
    }
}

extension RankingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 68
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        if section == 0 {
            headerView.addSubview(arrivedSectionHeaderView)
            arrivedSectionHeaderView.snp.makeConstraints {
                $0.centerY.leading.trailing.height.equalTo(headerView)
            }
        } else if section == 1 {
            headerView.addSubview(startSectionHeaderView)
            startSectionHeaderView.snp.makeConstraints {
                $0.centerY.leading.trailing.height.equalTo(headerView)
            }
        } else if section == 2 {
            headerView.addSubview(notstartSectionHeaderView)
            notstartSectionHeaderView.snp.makeConstraints {
                $0.centerY.leading.trailing.height.equalTo(headerView)
            }
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrivalUser.count
        } else if section == 1 {
            return notArrivalUser.count
        } else {
                        return notStartUser.count
//            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rankingView.dequeueReusableCell(withIdentifier: RankingViewCell.rankingCellID, for: indexPath) as! RankingViewCell
        
        if indexPath.section == 0 {
            cell.medal.isHidden = false
            cell.button.isHidden = true
            if indexPath.row == 0{
                cell.medal.medal.image = UIImage(named: "golden")
                cell.medal.backgroundColor = #colorLiteral(red: 1, green: 0.9294117647, blue: 0.5803921569, alpha: 1)
            } else if indexPath.row == 1 {
                cell.medal.medal.image = UIImage(named: "silver")
                cell.medal.backgroundColor = .none
            } else if indexPath.row == 2 {
                cell.medal.medal.image = UIImage(named: "bronze")
                cell.medal.backgroundColor = .none
            } else {
                cell.medal.isHidden = true
            }
            cell.setData(data: arrivalUser[indexPath.row])
        } else if indexPath.section == 1 {
            cell.medal.isHidden = true
            cell.button.isHidden = false
            cell.tapped = { [unowned self] in
                cell.buttonState = false
                Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
                    cell.buttonState = true
                }
                bottomSheetUp()
            }
            cell.setData(data: notArrivalUser[indexPath.row])
        } else if indexPath.section == 2 {
            cell.setData(data: notStartUser[indexPath.row])
            cell.button.isHidden = false
            cell.medal.isHidden = true
        }
        return cell
    }
    
}

extension RankingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bottomSheet.collectionView.dequeueReusableCell(withReuseIdentifier: UrgeMessageCollectionViewCell.cellId, for: indexPath) as! UrgeMessageCollectionViewCell
        cell.urgeMessageLabel.text = urgeMessageList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = urgeMessageList[indexPath.row]
        
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)
        ])
        return itemSize
    }
}
