//
//  MapViewController.swift
//  MannaDemo
//
//  Created by once on 2020/10/21.
//

import UIKit
import NMapsMap
import CoreLocation
import SwiftyJSON
import SocketIO
import AudioToolbox

protocol ChatSet {
    var chattingViewController: chattingView? { get set }
    var rankingViewController: RankingView? { get set }
}

class MapViewController: UIViewController, ChatSet{
    var defaultOverlayImage = DefaultOverlayView(frame: CGRect(x: 0, y: 0, width: 45, height: 75)).asImage()
    var compassOverlayImage = CompassOverLayView(frame: CGRect(x: 0, y: 0, width: 45, height: 75)).asImage()
<<<<<<< HEAD
=======
    
    
>>>>>>> feat : 랭킹뷰 대응 끝
    var rankingViewController: RankingView?
    var chattingViewController: chattingView?
    let userName: [String] = ["우석", "연재", "상원", "재인", "효근", "규리", "종찬", "용권"]
    var userImage: [UIImage] = []
    var chatView: UIView?
    var meetInfo: NewManna?
    lazy var manager = SocketManager(socketURL: URL(string: "https://manna.duckdns.org:19999")!, config: [.log(false), .compress, .connectParams(["deviceToken": MannaDemo.myUUID!,"mannaID":meetInfo!.uuid])])
    var locationSocket: SocketIOClient!
    var chatSocket: SocketIOClient!
    var locationManager = CLLocationManager()
    var tokenWithMarker: [String : NMFMarker] = [:]
    let mapView = NMFMapView()
    let backButton = UIButton()
    let multipartPath = NMFMultipartPath()
    var cameraUpdateOnlyOnceFlag = true
    var myLatitude: Double = 0
    var myLongitude: Double = 0
    //이거 랭킹 뷰컨으로 옮겨질듯
    var imageToNameFlag = true
    var toastLabel = UILabel()
    var cameraState = UIButton()
    var myLocationButton = UIButton()
    var goalMarker = NMFMarker()
    var disconnectToggleFlag = false
    var cameraTrakingToggleFlag = true
    var cameraTrakingModeFlag = true
    lazy var goToChatGesture = UITapGestureRecognizer(target: self, action: #selector(goToChatGestureFunc))
    lazy var tempTimerGesture = UITapGestureRecognizer(target: self, action: #selector(didClickedTimerView))
    lazy var userListForCollectionView: [User] = Array(rankingViewController!.userList.values)
    var presenter = MapPresenter()
//    var imageView: UIImageView = {
//        let view = UIImageView()
//        view.image = DisconnectProfileVIew(name: "상원", frame: CGRect(x: 100, y: 100, width: MannaDemo.convertWidth(value: 63), height: MannaDemo.convertWidth(value: 69.61))).asImage()
//        view.frame = CGRect(x: 100, y: 100, width: 60, height: 60)
//        return view
//    }()
    var bottomBar = BottomBar()
    var viewForTransition = UIView()
    
    // MARK: ViewDidLoad
    override func viewDidAppear(_ animated: Bool) {
        
        if cameraUpdateOnlyOnceFlag {
            camereUpdateOnlyOnce()
            cameraUpdateOnlyOnceFlag = false
        }
        
    }
    
    // MARK: ViewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        locationSocket.disconnect()
        chatSocket.disconnect()
        chattingViewController!.chatMessage.removeAll()
        print(chatSocket.status)
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.currentRanking(userList: rankingViewController!.userList) { userList in
            self.rankingViewController!.userList = userList
        }
        checkedLocation()
        locationSocket = manager.socket(forNamespace: "/location")
        chatSocket = manager.socket(forNamespace: "/chat")
        locationSocket.connect()
        chatSocket.connect()
        
        
        locationSocket.on("locationConnect") { [self] (array, ack) in
            rankingViewController!.userList[MannaDemo.myUUID!]?.state = true
            self.setCollcetionViewItem()
        }
        chatSocket.on("chatConnect") { [self] (array, ack) in
            print(ack)
            print(chatSocket.status)
        }
        chatSocket.on("chatDisconnect") { (array, ack) in
            print(array)
        }
        locationSocket.on("locationDisconnect") { (array, ack) in
            print(array)
        }
        locationSocket.on("locationConnect") { (array, ack) in
            print(array)
        }
        chatSocket.on("chat") { [self] (array, ack) in
            let json = JSON(array)
            guard let test = json[0].string?.data(using: .utf8) else { return }
            guard let jsonData = try? JSON(test) else { return }
            guard let temp = "\(jsonData)".data(using: .utf8) else { return }
            let result: SocketMessage = try! JSONDecoder().decode(SocketMessage.self, from: temp)
            var newMessage: ChatMessage?
            if result.message != nil {
                let incoming: UserState = result.sender.deviceToken != MannaDemo.myUUID ? .other : .me
                switch result.sender.username {
                case "우석":
                    if let message = result.message?.message, let timestamp = result.message?.createTimestamp {
                        newMessage = ChatMessage(user: result.sender.username, text: message, timeStamp: timestamp, isIncoming: incoming, sendState: false)
                    }
                    break
                case "연재":
                    if let message = result.message?.message, let timestamp = result.message?.createTimestamp {
                        newMessage = ChatMessage(user: result.sender.username, text: message, timeStamp: timestamp, isIncoming: incoming, sendState: false)
                    }
                    break
                case "상원":
                    if let message = result.message?.message, let timestamp = result.message?.createTimestamp {
                        newMessage = ChatMessage(user: result.sender.username, text: message, timeStamp: timestamp, isIncoming: incoming, sendState: false)
                    }
                    break
                case "재인":
                    if let message = result.message?.message, let timestamp = result.message?.createTimestamp {
                        newMessage = ChatMessage(user: result.sender.username, text: message, timeStamp: timestamp, isIncoming: incoming, sendState: false)
                    }
                    break
                case "효근":
                    if let message = result.message?.message, let timestamp = result.message?.createTimestamp {
                        newMessage = ChatMessage(user: result.sender.username, text: message, timeStamp: timestamp, isIncoming: incoming, sendState: false)
                    }
                    break
                case "규리":
                    if let message = result.message?.message, let timestamp = result.message?.createTimestamp {
                        newMessage = ChatMessage(user: result.sender.username, text: message, timeStamp: timestamp, isIncoming: incoming, sendState: false)
                    }
                    break
                case "종찬":
                    if let message = result.message?.message, let timestamp = result.message?.createTimestamp {
                        newMessage = ChatMessage(user: result.sender.username, text: message, timeStamp: timestamp, isIncoming: incoming, sendState: false)
                    }
                    break
                case "용권":
                    if let message = result.message?.message, let timestamp = result.message?.createTimestamp {
                        newMessage = ChatMessage(user: result.sender.username, text: message, timeStamp: timestamp, isIncoming: incoming, sendState: false)
                    }
                    break
                default:
                    break
                }
            }
            guard let newMessageBinding = newMessage else { return }
            
            chattingViewController!.chatMessage.append(newMessageBinding)
            chattingViewController!.chatView.reloadData()
        }
        
        locationSocket.on("location") { [self] (array, ack) in
            var _: String?
            var deviceToken: String?
            var username: String?
            var lat_: Double?
            var lng_: Double?
            let json = JSON(array)
            if let data = json[0].string?.data(using: .utf8) {
                if let json = try? JSON(data) {
                    let temp = "\(json)".data(using: .utf8)
                    let result: SocketData = try! JSONDecoder().decode(SocketData.self, from: temp!)
                    deviceToken = result.sender.deviceToken
                    username = result.sender.username
                    guard let token = deviceToken else { return }
                    switch result.type {
                    case "LOCATION":
                        lat_ = result.location?.latitude
                        lng_ = result.location?.longitude
                        rankingViewController!.userList[token]?.state = true
                        break
                        
                    case "JOIN":
                        guard let name = username else { return }
                        rankingViewController!.userList[token]?.state = true
                        rankingViewController!.userList[token]?.networkValidTime = 0
                        self.marking()
                        self.showToast(message: "\(name)님 접속하셨습니다.")
                        self.setCollcetionViewItem()
                        break
                        
                    case "LEAVE":
                        guard let name = username else { return }
                        rankingViewController!.userList[token]?.networkValidTime = 61
                        self.marking()
                        self.setCollcetionViewItem()
                        self.showToast(message: "\(name)님 나가셨습니다.")
                        break
                        
                    default:
                        break
                    }
                    guard let lat = lat_ else { return }
                    guard let lng = lng_ else { return }
                    guard rankingViewController!.userList[token] != nil else { return }
                    rankingViewController!.userList[token]?.networkValidTime = 0
                    if token != MannaDemo.myUUID {
                        rankingViewController!.userList[token]?.latitude = lat
                        rankingViewController!.userList[token]?.longitude = lng
                        MannaAPI.getPath(lat: lat_!, lng: lng_!) { (result) in
                            rankingViewController!.userList[token]?.remainDistance = result.distance
                            rankingViewController!.userList[token]?.remainTime = result.duration
                        }
                    }
                }
            }
            
        }
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timeChecker), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(marking), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(toMyLocation), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(toWholeLocation), userInfo: nil, repeats: true)
        
        array()
        layout()
        didMarkerClicked()
        attribute()
    }
    
    // MARK: SendMessage
    @objc func sendMessage() {
        guard let text = chattingViewController!.inputBar.textView.text else { return }
        chatSocket.emit("chat", "\(text)")
        chattingViewController?.chatView.reloadData()
        chattingViewController!.inputBar.textView.text = ""
    }
    
    @objc func didClickedTimerView() {
//        timerView.tempToggleFlag.toggle()
//        rankingViewController?.userList[MannaDemo.myUUID!]?.state.toggle()
//        if timerView.tempToggleFlag {
//            UIView.animate(withDuration: 0.05, animations: {
//                self.timerView.snp.updateConstraints {
//                    $0.width.equalTo(MannaDemo.convertWidth(value: 10))
//                }
//                self.timerView.alpha = 0
//                self.view.setNeedsLayout()
//                self.view.layoutIfNeeded()
//            },completion: {_ in
//                UIView.animate(withDuration: 0.1) {
//                    self.timerView.alpha = 1
//                    self.timerView.snp.updateConstraints {
//                        $0.width.equalTo(MannaDemo.convertWidth(value: 115))
//                    }
//                    self.view.setNeedsLayout()
//                    self.view.layoutIfNeeded()
//                }
//            })
//
//        } else {
//            UIView.animate(withDuration: 0.05, animations: {
//                self.timerView.snp.updateConstraints {
//                    $0.width.equalTo(MannaDemo.convertWidth(value: 10))
//                }
//                self.timerView.alpha = 0
//                self.view.setNeedsLayout()
//                self.view.layoutIfNeeded()
//            },completion: {_ in
//                UIView.animate(withDuration: 0.1) {
//                    self.timerView.alpha = 1
//                    self.timerView.snp.updateConstraints {
//                        $0.width.equalTo(MannaDemo.convertWidth(value: 102))
//                    }
//                    self.view.setNeedsLayout()
//                    self.view.layoutIfNeeded()
//                }
//            })
//        }
    }
    
    // MARK: Attribute
    func attribute() {
        chattingViewController!.inputBar.sendButton.do {
            $0.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
//        view.addSubview(imageView)
        
        backButton.do {
            $0.setImage(#imageLiteral(resourceName: "back"), for: .normal)
            $0.frame.size.width = 40
            $0.frame.size.height = 40
            $0.layer.cornerRadius = $0.frame.width / 2
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(back), for: .touchUpInside)
        }
        mapView.do {
            $0.frame = view.frame
            $0.addCameraDelegate(delegate: self)
            $0.mapType = .navi
            $0.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true)
            $0.symbolScale = 0.85
            $0.logoInteractionEnabled = false
            $0.maxZoomLevel = 18
            $0.positionMode = .direction
        }
        mapView.locationOverlay.do {
            $0.icon = NMFOverlayImage(image: defaultOverlayImage)
            $0.iconWidth = MannaDemo.convertWidth(value: 60)
            $0.iconHeight = MannaDemo.convertWidth(value: 100)
        }
        locationManager.do {
            $0.delegate = self
            $0.requestWhenInUseAuthorization()
            $0.desiredAccuracy = kCLLocationAccuracyBest
            $0.startUpdatingLocation()
        }
        toastLabel.do {
            $0.backgroundColor = UIColor.lightGray
            $0.textColor = UIColor.black
            $0.textAlignment = .center
            $0.alpha = 0
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        cameraState.do {
            $0.setImage(#imageLiteral(resourceName: "tree"), for: .normal)
            $0.addTarget(self, action: #selector(didMyLocationButtonClicked), for: .touchUpInside)
            $0.imageEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.tag = 1
            $0.dropShadow()
        }
        myLocationButton.do {
            $0.alpha = 0.4
            $0.setImage(#imageLiteral(resourceName: "mylocation"), for: .normal)
            $0.addTarget(self, action: #selector(didMyLocationButtonClicked), for: .touchUpInside)
            $0.imageEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.tag = 2
        }
        goalMarker.do {
            $0.iconImage = NMFOverlayImage(image: #imageLiteral(resourceName: "goal"))
            $0.height = MannaDemo.convertWidth(value: 48)
            $0.width = MannaDemo.convertWidth(value: 48)
            $0.position = NMGLatLng(lat: 37.475427, lng: 126.980378)
            $0.mapView = mapView
            $0.isForceShowIcon = true
        }
        bottomBar.do {
            $0.chatButton.addGestureRecognizer(goToChatGesture)
            $0.rankingBUtton.addTarget(self, action: #selector(showRankingView), for: .touchUpInside)
            $0.timerView.addGestureRecognizer(tempTimerGesture)
        }
        rankingViewController?.do {
            $0.bottomBar.chatButton.addTarget(self, action: #selector(didClickedChatButtonInRankingView), for: .touchUpInside)
            $0.bottomBar.rankingBUtton.addTarget(self, action: #selector(showRankingView), for: .touchUpInside)
            $0.dismissButton.addTarget(self, action: #selector(hideBackgroundView), for: .touchUpInside)
        }
        viewForTransition.do {
            $0.backgroundColor = .white
            $0.isHidden = true
        }
    }
    
    // MARK: layout
    func layout() {
        [mapView, cameraState, myLocationButton, backButton, toastLabel, bottomBar, viewForTransition].forEach { view.addSubview($0) }
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(MannaDemo.convertHeight(value: 46))
            $0.leading.equalToSuperview().offset(15)
            $0.width.height.equalTo(MannaDemo.convertHeight(value: 45))
        }
        toastLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.centerY.equalTo(view).offset(-100)
            $0.width.equalTo(MannaDemo.convertWidth(value: 200))
            $0.height.equalTo(MannaDemo.convertHeight(value: 50))
        }
        myLocationButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(MannaDemo.convertWidth(value: 45))
            $0.leading.equalTo(cameraState.snp.trailing).offset(MannaDemo.convertWidth(value: 10.88))
            $0.width.height.equalTo(45)
        }
        cameraState.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(MannaDemo.convertWidth(value: 45))
            $0.trailing.equalToSuperview().offset(-MannaDemo.convertWidth(value: 70.88))
            $0.width.height.equalTo(45)
        }
        bottomBar.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.snp.bottom).offset(-90)
        }
        viewForTransition.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view)
        }
    }
    
    //MARK: 마커 생성
    func array() {
        rankingViewController!.userList.keys.forEach { tokenWithMarker[$0] = NMFMarker()}
        for marker in tokenWithMarker.values {
            marker.width = MannaDemo.convertWidth(value: 56)
            marker.height = MannaDemo.convertWidth(value: 62.61)
        }
    }
    
    //MARK: 닉네임 이미지 셋
    func nicknameImageSet() {
        _ = 0
    }
    
    @objc func showRankingView() {
        
        viewForTransition.isHidden = false
        
        presenter.currentRanking(userList: rankingViewController!.userList) { userList in
            self.rankingViewController!.userList = userList
        }
        self.rankingViewController!.view.backgroundColor = .white
        self.rankingViewController!.modalPresentationStyle = .custom
        self.rankingViewController!.modalTransitionStyle = .crossDissolve
        self.present(self.rankingViewController!, animated: true)
    }
    
    //MARK: 마커 클릭 이벤트
    func didMarkerClicked() {
        tokenWithMarker.keys.forEach { key in
            cameraTrakingToggleFlag = false
            tokenWithMarker[key]?.touchHandler = { [self] (overlay: NMFOverlay) -> Bool in
                let lat = rankingViewController!.userList[key]?.latitude
                let lng = rankingViewController!.userList[key]?.longitude
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat!, lng: lng!))
                cameraUpdate.animation = .easeOut
                cameraUpdate.animationDuration = 0.3
                mapView.moveCamera(cameraUpdate)
                
                MannaAPI.getPath(lat: lat!, lng: lng!) { result in
                    multipartPath.lineParts = [
                        NMGLineString(points: result.path!)
                    ]
                    multipartPath.colorParts = [
                        NMFPathColor(color: UIColor(named: "keyColor")!, outlineColor: UIColor.white, passedColor: UIColor.gray, passedOutlineColor: UIColor.lightGray)
                    ]
                    multipartPath.mapView = mapView
                }
                return true
            }
        }
    }
    
    //MARK: 컬렉션 뷰 아이템 세팅
    func setCollcetionViewItem() {
//        userListForCollectionView = Array(rankingViewController!.userList.values)
//        userListForCollectionView.sort { $0.state && !$1.state}
//        userListForCollectionView.sort { $0.remainTime < $1.remainTime }
    }
    
    //MARK: init 카메라 세팅
    func camereUpdateOnlyOnce() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: myLatitude, lng: myLongitude))
        mapView.zoomLevel = 10
        mapView.moveCamera(cameraUpdate)
    }
    
    //MARK: 토스트 메세지
    func showToast(message: String) {
        self.toastLabel.text = message
        self.toastLabel.alpha = 1
        UIView.animate(withDuration: 1.5) {
            self.toastLabel.alpha = 0
        } completion: { _ in
        }
    }
    
    @objc func didMyLocationButtonClicked(_ sender: UIButton) {
        multipartPath.mapView = nil
        cameraTrakingToggleFlag = true
        
        //산일때
        if cameraState.currentImage == UIImage(named: "forest") {
            cameraTrakingModeFlag = true
            if sender.tag == 1 {
                //산<->나무 버튼 클릭
                //현: 숲 트래킹 유무 상관 x -> 후: 나무 트래킹 o
                tokenWithMarker[MannaDemo.myUUID!]!.mapView = mapView
                mapView.positionMode = .normal
                myLocationButton.alpha = 0.4
                cameraState.setImage(#imageLiteral(resourceName: "tree"), for: .normal)
                myLocationButton.setImage(#imageLiteral(resourceName: "mylocation"), for: .normal)
                toMyLocation()
            } else {
                //내위치 버튼 클릭
                if myLocationButton.alpha == 0.4000000059604645 {
                    //현재 트래킹 중이였음
                    cameraTrakingToggleFlag = false
                    myLocationButton.setImage(#imageLiteral(resourceName: "mylocationtracking"), for: .normal)
                    myLocationButton.alpha = 1
                    let cameraUpdate = NMFCameraUpdate(zoomTo: 17)
                    mapView.moveCamera(cameraUpdate)
                    mapView.positionMode = .compass
                    mapView.locationOverlay.icon = NMFOverlayImage(image: compassOverlayImage)
                    mapView.locationOverlay.iconWidth = MannaDemo.convertWidth(value: 60)
                    mapView.locationOverlay.iconHeight = MannaDemo.convertWidth(value: 100)
                    print(mapView.locationOverlay.iconWidth)
                    print(mapView.locationOverlay.iconHeight)
                    
                } else {
                    //트래킹 중이 아닌거지
                    mapView.positionMode = .normal
                    myLocationButton.alpha = 0.4
                    cameraTrakingModeFlag.toggle()
                    myLocationButton.setImage(#imageLiteral(resourceName: "mylocation"), for: .normal)
                    toWholeLocation()
                    mapView.locationOverlay.icon = NMFOverlayImage(image: defaultOverlayImage)
                    mapView.locationOverlay.iconWidth = MannaDemo.convertWidth(value: 60)
                    mapView.locationOverlay.iconHeight = MannaDemo.convertWidth(value: 100)
                }
            }
        } else {
            //나무일때
            cameraTrakingModeFlag = false
            if sender.tag == 1 {
                mapView.positionMode = .normal
                myLocationButton.alpha = 0.4
                cameraState.setImage(#imageLiteral(resourceName: "forest"), for: .normal)
                myLocationButton.setImage(#imageLiteral(resourceName: "mylocation"), for: .normal)
                toWholeLocation()
            } else {
                if myLocationButton.alpha == 0.4000000059604645{
                    //지금 트래킹 중인거고
                    cameraTrakingToggleFlag = false
                    myLocationButton.setImage(#imageLiteral(resourceName: "mylocationtracking"), for: .normal)
                    myLocationButton.alpha = 1
                    let cameraUpdate = NMFCameraUpdate(zoomTo: 17)
                    mapView.moveCamera(cameraUpdate)
                    
                    mapView.positionMode = .compass
                    mapView.locationOverlay.icon = NMFOverlayImage(image: compassOverlayImage)
                    mapView.locationOverlay.iconWidth = MannaDemo.convertWidth(value: 60)
                    mapView.locationOverlay.iconHeight = MannaDemo.convertWidth(value: 100)
                } else {
                    mapView.positionMode = .normal
                    myLocationButton.alpha = 0.4
                    cameraTrakingModeFlag.toggle()
                    myLocationButton.setImage(#imageLiteral(resourceName: "mylocation"), for: .normal)
                    toMyLocation()
                    mapView.locationOverlay.icon = NMFOverlayImage(image: defaultOverlayImage)
                    mapView.locationOverlay.iconWidth = MannaDemo.convertWidth(value: 60)
                    mapView.locationOverlay.iconHeight = MannaDemo.convertWidth(value: 100)
                }
            }
        }
    }
    
    //MARK: 내위치 카메라 세팅
    @objc func toMyLocation() {
        if cameraTrakingToggleFlag && cameraTrakingModeFlag && mapView.positionMode != .compass {
            let cameraUpdate =  NMFCameraUpdate(scrollTo: NMGLatLng(lat: mapView.locationOverlay.location.lat, lng: mapView.locationOverlay.location.lng),zoomTo: 15)
            cameraUpdate.animation = .fly
            cameraUpdate.animationDuration = 0.4
            mapView.moveCamera(cameraUpdate)
        }
    }
    
    //MARK: 모두의 위치 카메라 세팅
    @objc func toWholeLocation() {
        if cameraTrakingToggleFlag && cameraTrakingModeFlag == false && mapView.positionMode != .compass {
            let minLatLng = NMGLatLng(lat: 150, lng: 150)
            let maxLatLng = NMGLatLng(lat: 0, lng: 0)
            
            rankingViewController!.userList.keys.forEach {
                if rankingViewController!.userList[$0]?.state == true {
                    print(rankingViewController!.userList[$0]!.longitude)
                    if rankingViewController!.userList[$0]!.longitude != 0 && rankingViewController!.userList[$0]!.latitude != 0 {
                        if minLatLng.lat > rankingViewController!.userList[$0]!.latitude {
                            minLatLng.lat = rankingViewController!.userList[$0]!.latitude
                        }
                        if minLatLng.lng > rankingViewController!.userList[$0]!.longitude {
                            minLatLng.lng = rankingViewController!.userList[$0]!.longitude
                        }
                        if maxLatLng.lat < rankingViewController!.userList[$0]!.latitude {
                            maxLatLng.lat = rankingViewController!.userList[$0]!.latitude
                        }
                        if maxLatLng.lng < rankingViewController!.userList[$0]!.longitude {
                            maxLatLng.lng = rankingViewController!.userList[$0]!.longitude
                        }
                    }
                }
            }
            let cameraUpdate = NMFCameraUpdate(fit: NMGLatLngBounds(southWest: minLatLng, northEast: maxLatLng), padding: 90)
            cameraUpdate.animation = .fly
            cameraUpdate.animationDuration = 0.4
            mapView.moveCamera(cameraUpdate)
        }
    }
    
    //MARK: 채팅창 클릭
    @objc func goToChatGestureFunc() {
        chattingViewController!.chatView.reloadData()
        present(chattingViewController!, animated: true)
    }
    
    @objc func didClickedChatButtonInRankingView() {
        chattingViewController!.chatView.reloadData()
        rankingViewController?.dismiss(animated: false)
        
        self.chattingViewController!.modalPresentationStyle = .custom
        self.chattingViewController!.modalTransitionStyle = .crossDissolve
        present(chattingViewController!, animated: true)
    }
    
    //MARK: 뒤로가기
    @objc func back() {
        self.dismiss(animated: true)
    }
    
    //MARK: 마커 전체 세팅
    @objc func marking() {
        for key in rankingViewController!.userList.keys {
            if let user = rankingViewController!.userList[key] {
                if imageToNameFlag {
                    if user.networkValidTime > 60 {
                        //연결이 끊겼을 때 닉네임프로필 + 끊긴 이미지
                        tokenWithMarker[key]?.iconImage = (rankingViewController?.disconnectProfileImageArray[(user.name)!])!
                    } else {
                        tokenWithMarker[key]?.iconImage = (rankingViewController?.locationProfileImageArray[(user.name)!])!
                    }
                } else {
                    if user.networkValidTime > 60 {
                        //여결이 끊겼을 때 사진프로필 + 끊긴 이미지
                        tokenWithMarker[key]?.iconImage = (rankingViewController?.disconnectProfileImageArray[(user.name)!])!
                    } else {
                        tokenWithMarker[key]?.iconImage = (rankingViewController?.locationProfileImageArray[(user.name)!])!
                    }
                }
                if (rankingViewController!.userList[key]?.state)! {
                    if key != MannaDemo.myUUID {
                        tokenWithMarker[key]?.position = NMGLatLng(lat: rankingViewController!.userList[key]!.latitude, lng: rankingViewController!.userList[key]!.longitude)
                        tokenWithMarker[key]?.mapView = mapView
                    } else if key == MannaDemo.myUUID && mapView.positionMode != .compass{
//
                    }
                }
            }
        }
        
    }
    
    @objc func hideBackgroundView() {
        viewForTransition.isHidden = true
    }
    
    //MARK: 위치권한 확인
    func checkedLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            let alter = UIAlertController(title: "위치권한 설정이 '안함'으로 되어있습니다.", message: "앱 설정 화면으로 가시겠습니까? \n '아니오'를 선택하시면 앱이 종료됩니다.", preferredStyle: UIAlertController.Style.alert)
            let logOkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default){
                (action: UIAlertAction) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                } else {
                    UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                }
            }
            let logNoAction = UIAlertAction(title: "아니오", style: UIAlertAction.Style.destructive){
                (action: UIAlertAction) in
                exit(0)
            }
            alter.addAction(logNoAction)
            alter.addAction(logOkAction)
            self.present(alter, animated: true, completion: nil)
        }
    }
    
    //MARK: 사용자상태 처리
    @objc func timeChecker() {
        rankingViewController!.userList.keys.forEach {
            if rankingViewController!.userList[$0]?.state == true {
                rankingViewController!.userList[$0]?.networkValidTime += 1
            }
        }
    }   
}
