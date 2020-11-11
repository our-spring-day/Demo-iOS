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


protocol test {
    var chatView: UIView? { get set}
}
extension MapViewController: test {
    
}

class MapViewController: UIViewController{
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
    var userListForCollectionView: [User] = Array(UserModel.userList.values)
    
    var imageToNameFlag = true
    var toastLabel = UILabel()
    var cameraState = UIButton()
    var myLocationButton = UIButton()
    lazy var goToChatGesture = UITapGestureRecognizer(target: self, action: #selector(goToChatGestureFunc))
    var goalMarker = NMFMarker()
    var disconnectToggleFlag = false
    var cameraTrakingToggleFlag = true
    var cameraTrakingModeFlag = true
    var rankingBUtton = UIButton()
    var chatBUtton = UIButton()
    var timerView = TimerView(.mapView)
    
    // MARK: ViewDidLoad
    override func viewDidAppear(_ animated: Bool) {
        if cameraUpdateOnlyOnceFlag {
            camereUpdateOnlyOnce()
            cameraUpdateOnlyOnceFlag = false
        }
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        GetMannaAPI.getManna()
        checkedLocation()
        locationSocket = manager.socket(forNamespace: "/location")
        chatSocket = manager.socket(forNamespace: "/chat")
        locationSocket.connect()
        chatSocket.connect()
        locationSocket.on("locationConnect") { (array, ack) in
            UserModel.userList[MannaDemo.myUUID!]?.state = true
            self.setCollcetionViewItem()
        }
        chatSocket.on("chat") { (array, ack) in
            let json = JSON(array)
            guard let test = json[0].string?.data(using: .utf8) else { return }
            guard let jsonData = try? JSON(test) else { return }
            guard let temp = "\(jsonData)".data(using: .utf8) else { return }
            let result: SocketMessage = try! JSONDecoder().decode(SocketMessage.self, from: temp)
            if result.message != nil {
                switch result.sender.username {
                case "우석":
                    if let message = result.message?.message {
                        let incoming = result.sender.deviceToken != MannaDemo.myUUID
                        print(incoming)
                        let message = ChatMessage(user: result.sender.username, text: message, isIncoming: incoming, sendState: false)
                        ChattingViewController.shared.chatMessage.append(message)
                    }
                    break
                case "연재":
                    if let message = result.message?.message {
                        let incoming = result.sender.deviceToken != MannaDemo.myUUID
                        print(incoming)
                        let message = ChatMessage(user: result.sender.username, text: message, isIncoming: incoming, sendState: false)
                        ChattingViewController.shared.chatMessage.append(message)
                    }
                    break
                case "상원":
                    if let message = result.message?.message {
                        let incoming = result.sender.deviceToken != MannaDemo.myUUID
                        print(incoming)
                        let message = ChatMessage(user: result.sender.username, text: message, isIncoming: incoming, sendState: false)
                        ChattingViewController.shared.chatMessage.append(message)
                    }
                    break
                case "재인":
                    if let message = result.message?.message {
                        let incoming = result.sender.deviceToken != MannaDemo.myUUID
                        print(incoming)
                        let message = ChatMessage(user: result.sender.username, text: message, isIncoming: incoming, sendState: false)
                        ChattingViewController.shared.chatMessage.append(message)
                    }
                    break
                case "효근":
                    if let message = result.message?.message {
                        let incoming = result.sender.deviceToken != MannaDemo.myUUID
                        print(incoming)
                        let message = ChatMessage(user: result.sender.username, text: message, isIncoming: incoming, sendState: false)
                        ChattingViewController.shared.chatMessage.append(message)
                    }
                    break
                case "규리":
                    if let message = result.message?.message {
                        let incoming = result.sender.deviceToken != MannaDemo.myUUID
                        print(incoming)
                        let message = ChatMessage(user: result.sender.username, text: message, isIncoming: incoming, sendState: false)
                        ChattingViewController.shared.chatMessage.append(message)
                    }
                    break
                case "종찬":
                    if let message = result.message?.message {
                        let incoming = result.sender.deviceToken != MannaDemo.myUUID
                        print(incoming)
                        let message = ChatMessage(user: result.sender.username, text: message, isIncoming: incoming, sendState: false)
                        ChattingViewController.shared.chatMessage.append(message)
                    }
                    break
                case "용권":
                    if let message = result.message?.message {
                        let incoming = result.sender.deviceToken != MannaDemo.myUUID
                        print(incoming)
                        let message = ChatMessage(user: result.sender.username, text: message, isIncoming: incoming, sendState: false)
                        ChattingViewController.shared.chatMessage.append(message)
                    }
                    break
                default:
                    break
                }
            }
            ChattingViewController.shared.chatView.reloadData()
        }
        locationSocket.on("location") { (array, ack) in
            var _: String?
            var deviceToken: String?
            var username: String?
            var lat_: Double?
            var lng_: Double?
            let json = JSON(array)
            if let data = json[0].string?.data(using: .utf8) {
                if let json = try? JSON(data) {
                    print("이게 까기전", json)
                    let temp = "\(json)".data(using: .utf8)
                    let result: SocketData = try! JSONDecoder().decode(SocketData.self, from: temp!)
                    deviceToken = result.sender.deviceToken
                    username = result.sender.username
                    guard let token = deviceToken else { return }
                    switch result.type {
                    case "LOCATION":
                        lat_ = result.location?.latitude
                        lng_ = result.location?.longitude
                        UserModel.userList[token]?.state = true
                        break
                        
                    case "JOIN":
                        guard let name = username else { return }
                        UserModel.userList[token]?.state = true
                        UserModel.userList[token]?.networkValidTime = 0
                        self.marking()
                        self.showToast(message: "\(name)님 접속하셨습니다.")
                        self.setCollcetionViewItem()
                        break
                        
                    case "LEAVE":
                        guard let name = username else { return }
                        UserModel.userList[token]?.networkValidTime = 61
                        self.marking()
                        self.setCollcetionViewItem()
                        self.showToast(message: "\(name)님 나가셨습니다.")
                        break
                        
                    default:
                        break
                    }
                    guard let lat = lat_ else { return }
                    guard let lng = lng_ else { return }
                    guard UserModel.userList[token] != nil else { return }
                    UserModel.userList[token]?.networkValidTime = 0
                    if token != MannaDemo.myUUID {
                        UserModel.userList[token]?.latitude = lat
                        UserModel.userList[token]?.longitude = lng
                        PathAPI.getPath(lat: lat_!, lng: lng_!) { (result) in
                            UserModel.userList[token]?.remainDistance = result.distance
                            UserModel.userList[token]?.remainTime = result.duration
                        }
                    }
                    self.setCollcetionViewItem()
                }
            }
            
        }
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeChecker), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(marking), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(toMyLocation), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(toWholeLocation), userInfo: nil, repeats: true)
        
        array()
        layout()
        didMarkerClicked()
        attribute()
    }
    
    @objc func sendMessage() {
        guard let text = ChattingViewController.shared.textField.text else { return }
        chatSocket.emit("chat", "\(text)")
        ChattingViewController.shared.scrollBottom()
        ChattingViewController.shared.textField.text = ""
    }
    
    // MARK: Attribute
    func attribute() {
        ChattingViewController.shared.sendButton.do {
            $0.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
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
            $0.icon = NMFOverlayImage(image: #imageLiteral(resourceName: "overlay"))
            $0.circleOutlineColor = .blue
            $0.circleOutlineWidth = 2
            $0.circleColor = .red
            $0.circleRadius = 0.1
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
        rankingBUtton.do {
            $0.backgroundColor = .white
            $0.setImage(#imageLiteral(resourceName: "ranking"), for: .normal)
            $0.layer.cornerRadius = MannaDemo.convertHeight(value: 53) / 2
            $0.layer.masksToBounds = true
            $0.imageEdgeInsets = UIEdgeInsets(top: MannaDemo.convertHeight(value: 15), left: MannaDemo.convertHeight(value: 14.5), bottom: MannaDemo.convertHeight(value: 14.5), right: MannaDemo.convertHeight(value: 14.5))
            $0.addTarget(self, action: #selector(showRankingView), for: .touchUpInside)
            $0.dropShadow()
        }
        chatBUtton.do {
            $0.backgroundColor = .white
            $0.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
            $0.layer.cornerRadius = MannaDemo.convertHeight(value: 53) / 2
            $0.layer.masksToBounds = true
            $0.imageEdgeInsets = UIEdgeInsets(top: MannaDemo.convertHeight(value: 17), left: MannaDemo.convertHeight(value: 16.5), bottom: MannaDemo.convertHeight(value: 16), right: MannaDemo.convertHeight(value: 16.5))
            $0.dropShadow()
            $0.addGestureRecognizer(goToChatGesture)
        }
    }
    
    // MARK: layout
    func layout() {
        [mapView, cameraState, myLocationButton, backButton, timerView, toastLabel, chatBUtton, rankingBUtton].forEach { view.addSubview($0) }
        
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
        timerView.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.centerY.equalTo(backButton)
            $0.width.equalTo(MannaDemo.convertWidth(value: 102))
            $0.height.equalTo(MannaDemo.convertHeight(value: 45))
        }
        myLocationButton.snp.makeConstraints {
            $0.top.equalTo(cameraState.snp.bottom).offset(11)
            $0.trailing.equalToSuperview().offset(-22)
            $0.width.height.equalTo(40)
        }
        cameraState.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.trailing.equalToSuperview().offset(-22)
            $0.width.height.equalTo(40)
        }
        rankingBUtton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-34)
            $0.trailing.equalTo(view.snp.trailing).offset(-20)
            $0.width.height.equalTo(MannaDemo.convertHeight(value: 53))
        }
        chatBUtton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-34)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.width.height.equalTo(MannaDemo.convertHeight(value: 53))
        }
    }
    
    //MARK: 마커 생성
    func array() {
        UserModel.userList.keys.forEach { tokenWithMarker[$0] = NMFMarker()}
        for marker in tokenWithMarker.values {
            marker.width = MannaDemo.convertWidth(value: 5)
            marker.height = MannaDemo.convertWidth(value: 5)
        }
    }
    
    //MARK: 렌더링 이미지
    func renderImage() {
        for name in userName {
            let image = UserView(text: name).then({
                $0.layer.cornerRadius = 30
            })
            let renderImage = image.asImage()
            userImage.append(renderImage)
        }
    }
    
    //MARK: 닉네임 이미지 셋
    func nicknameImageSet() {
        _ = 0
        //        for key in UserModel.userList.keys {
        //            UserModel.userList[key]?.nicknameImage = userImage[count]
        //            count += 1
        //        }
    }

    @objc func showRankingView() {
        let view = RankingViewController()
        view.view.backgroundColor = .white
        view.modalPresentationStyle = .custom
        view.modalTransitionStyle = .crossDissolve
        self.present(view, animated: true)

    }
    //MARK: 마커 클릭 이벤트
    func didMarkerClicked() {
        tokenWithMarker.keys.forEach { key in
            cameraTrakingToggleFlag = false
            tokenWithMarker[key]?.touchHandler = { [self] (overlay: NMFOverlay) -> Bool in
                let lat = UserModel.userList[key]?.latitude
                let lng = UserModel.userList[key]?.longitude
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat!, lng: lng!))
                cameraUpdate.animation = .easeOut
                cameraUpdate.animationDuration = 0.3
                mapView.moveCamera(cameraUpdate)
                
                PathAPI.getPath(lat: lat!, lng: lng!) { result in
                    multipartPath.lineParts = [
                        NMGLineString(points: result.path)
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
        userListForCollectionView = Array(UserModel.userList.values)
        userListForCollectionView.sort { $0.state && !$1.state}
        userListForCollectionView.sort { $0.remainTime < $1.remainTime }
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
        mapView.positionMode = .compass
        multipartPath.mapView = nil
        cameraTrakingToggleFlag = true
        
        if cameraState.currentImage == UIImage(named: "forest") {
            cameraTrakingModeFlag = true
            if sender.tag == 1 {
                myLocationButton.alpha = 0.4
                cameraState.setImage(#imageLiteral(resourceName: "tree"), for: .normal)
                toMyLocation()
            } else {
                if myLocationButton.alpha == 0.4000000059604645 && sender.tag == 2 {
                    //지금 트래킹 중인거고
                    myLocationButton.setImage(#imageLiteral(resourceName: "mylocationtracking"), for: .normal)
                    mapView.positionMode = .compass
                } else {
                    //트래킹 중이 아닌거지
                    myLocationButton.alpha = 0.4
                    cameraTrakingModeFlag.toggle()
                    toWholeLocation()
                }
                
            }
        } else {
            cameraTrakingModeFlag = false
            if sender.tag == 1 {
                myLocationButton.alpha = 0.4
                cameraState.setImage(#imageLiteral(resourceName: "forest"), for: .normal)
                toWholeLocation()
            } else {
                if myLocationButton.alpha == 0.4000000059604645 && sender.tag == 2 {
                    //지금 트래킹 중인거고
                    myLocationButton.setImage(#imageLiteral(resourceName: "mylocationtracking"), for: .normal)
                    mapView.positionMode = .compass
                } else {
                    myLocationButton.alpha = 0.4
                    cameraTrakingModeFlag.toggle()
                    toMyLocation()
                }
            }
        }
    }
    
    //MARK: 내위치 카메라 세팅
    @objc func toMyLocation() {
        
        if cameraTrakingToggleFlag && cameraTrakingModeFlag && mapView.positionMode != .compass {
//            mapView.positionMode = .direction
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
            
            UserModel.userList.keys.forEach {
                if UserModel.userList[$0]?.state == true {
                    if UserModel.userList[$0]!.longitude != 0 && UserModel.userList[$0]!.latitude != 0 {
                        if minLatLng.lat > UserModel.userList[$0]!.latitude {
                            minLatLng.lat = UserModel.userList[$0]!.latitude
                        }
                        if minLatLng.lng > UserModel.userList[$0]!.longitude {
                            minLatLng.lng = UserModel.userList[$0]!.longitude
                        }
                        if maxLatLng.lat < UserModel.userList[$0]!.latitude {
                            maxLatLng.lat = UserModel.userList[$0]!.latitude
                        }
                        if maxLatLng.lng < UserModel.userList[$0]!.longitude {
                            maxLatLng.lng = UserModel.userList[$0]!.longitude
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
        let view = ChattingViewController.shared
        present(view, animated: true)
    }
    
    //MARK: 뒤로가기
    @objc func back() {
        self.dismiss(animated: true)
    }
    
    //MARK: 마커 전체 세팅
    @objc func marking() {
        
        for key in UserModel.userList.keys {
            let user = UserModel.userList[key]
            if imageToNameFlag {
                if user!.networkValidTime > 60 {
                    //연결이 끊겼을 때 닉네임프로필 + 끊긴 이미지
                    tokenWithMarker[key]?.iconImage = disconnectToggleFlag ?  NMFOverlayImage(image: UserModel.userList[key]!.disconnectProfileImage) : NMFOverlayImage(image: UserModel.userList[key]!.anotherdisconnectProfileImage)
                } else {
                    tokenWithMarker[key]?.iconImage = NMFOverlayImage(image: UserModel.userList[key]!.nicknameImage)
                }
            } else {
                if user!.networkValidTime > 60 {
                    //여결이 끊겼을 때 사진프로필 + 끊긴 이미지
                    tokenWithMarker[key]?.iconImage = disconnectToggleFlag ?  NMFOverlayImage(image: UserModel.userList[key]!.disconnectProfileImage) : NMFOverlayImage(image: UserModel.userList[key]!.anotherdisconnectProfileImage)
                } else {
                    tokenWithMarker[key]?.iconImage = NMFOverlayImage(image: UserModel.userList[key]!.profileImage)
                }
            }
            if (UserModel.userList[key]?.state)! {
                if key != MannaDemo.myUUID {
                    tokenWithMarker[key]?.position = NMGLatLng(lat: UserModel.userList[key]!.latitude, lng: UserModel.userList[key]!.longitude)
                    tokenWithMarker[key]?.mapView = mapView
                } else if key == MannaDemo.myUUID {
                    //                    tokenWithMarker[key]?.position = NMGLatLng(lat: mapView.locationOverlay.location.lat, lng: mapView.locationOverlay.location.lng)
                    //                    tokenWithMarker[key]?.mapView = mapView
                }
            }
        }
        
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
        UserModel.userList.keys.forEach {
            if UserModel.userList[$0]?.state == true {
                UserModel.userList[$0]?.networkValidTime += 1
            }
        }
    }   
}
