//
//  MapViewController.swift
//  MannaDemo
//
//  Created by once on 2020/10/21.
//

import UIKit
import NMapsMap
import CoreLocation
//import Starscream
import SwiftyJSON
import Lottie
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
    
    var manager = SocketManager(socketURL: URL(string: "https://manna.duckdns.org:19999")!, config: [.log(false), .compress, .connectParams(["deviceToken": MannaDemo.myUUID!,"mannaID":"96f35135-390f-496c-af00-cdb3a4104550"])])
    
    var locationSocket: SocketIOClient!
    var chatSocket: SocketIOClient!
    
    
    var locationManager = CLLocationManager()
    var tokenWithMarker: [String : NMFMarker] = [:]
    let mapView = NMFMapView()
    let backButton = UIButton()
    var timerView = TimerView()
    var bottomSheet = BottomSheetViewController()
    let multipartPath = NMFMultipartPath()
    var animationView = AnimationView(name:"12670-flying-airplane")
    var cameraUpdateOnlyOnceFlag = true
    var myLatitude: Double = 0
    var myLongitude: Double = 0
    var zoomLevel: Double = 10
    var userListForCollectionView: [User] = Array(UserModel.userList.values)
    var imageToNameFlag = true
    var toastLabel = UILabel()
    var cameraState = UIButton()
    var bottomTabView = BottomTabView()
    var myLocationButton = UIButton()
    lazy var testGesture = UITapGestureRecognizer(target: self, action: #selector(testGestureFunc))
    lazy var tempToggleGesture = UITapGestureRecognizer(target: self, action: #selector(didtempToggleButtonClicked))
    var cameraStateFlag = true
    var goalMarker = NMFMarker()
    var tempToggleButton = UIButton()
    var disconnectToggleFlag = false
    var cameraTrakingToggleFlag = true
    var cameraTrakingModeFlag = true
    
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
        checkedLocation()
        locationSocket = manager.socket(forNamespace: "/location")
        chatSocket = manager.socket(forNamespace: "/chat")
        
        locationSocket.connect()
        chatSocket.connect()
        
        
        locationSocket.on("location") { (array, ack) in
            print(array)
        }
        
        
        
        
        
        
        
        chatView = bottomSheet.chatViewController.backgroundView
        myLocationButton.isHidden = true

        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeChecker), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(marking), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(toMyLocation), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(toWholeLocation), userInfo: nil, repeats: true)
        
        array()
        layout()
        didMarkerClicked()
        attribute()
        bottomSheet.runningTimeController.collectionView.reloadData()
    }
    
    func attribute() {
//        socket.do {
//            $0.delegate = self
//        }
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
        bottomSheet.do {
            $0.runningTimeController.collectionView.delegate = self
            $0.runningTimeController.collectionView.dataSource = self
            $0.parentView = self.view
            $0.view.frame = CGRect(x: 0, y: MannaDemo.convertHeigt(value: 470), width: view.frame.width, height: view.frame.height)
            $0.chatViewController.backgroundView.addGestureRecognizer(testGesture)
            $0.rankingViewController.animationView.addGestureRecognizer(tempToggleGesture)
        }
        bottomTabView.do {
            $0.backgroundColor = .white
            $0.chat.addTarget(self, action: #selector(didClickecBottomTabButton), for: .touchUpInside)
            $0.runningTime.addTarget(self, action: #selector(didClickecBottomTabButton), for: .touchUpInside)
            $0.ranking.addTarget(self, action: #selector(didClickecBottomTabButton), for: .touchUpInside)
        }
        cameraState.do {
            $0.setImage(#imageLiteral(resourceName: "tree"), for: .normal)
            $0.addTarget(self, action: #selector(didMyLocationButtonClicked), for: .touchUpInside)
            $0.imageEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.tag = 1
            $0.dropShadow()
        }
        myLocationButton.do {
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
    }
    
    func layout() {
        [mapView, cameraState, myLocationButton, backButton, timerView, bottomSheet.view, bottomTabView, toastLabel].forEach { view.addSubview($0) }
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.leading.equalToSuperview().offset(22)
            $0.width.height.equalTo(40)
        }
        toastLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.centerY.equalTo(view).offset(-100)
            $0.width.equalTo(MannaDemo.convertWidth(value: 200))
            $0.height.equalTo(MannaDemo.convertHeigt(value: 50))
        }
        timerView.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.centerY.equalTo(backButton)
            $0.width.equalTo(MannaDemo.convertWidth(value: 130))
            $0.height.equalTo(MannaDemo.convertHeigt(value: 45))
        }
        bottomTabView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view)
            $0.height.equalTo(MannaDemo.convertHeigt(value: MannaDemo.convertHeigt(value: 85)))
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
    }
    
    //MARK: 마커 생성
    func array() {
        UserModel.userList.keys.map { tokenWithMarker[$0] = NMFMarker()}
        for marker in tokenWithMarker.values {
            marker.width = MannaDemo.convertWidth(value: 5)
            marker.height = MannaDemo.convertWidth(value: 5)
        }
    }
    
    //MARK: 렌더링 이미지ㅇ
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
        var count = 0
//        for key in UserModel.userList.keys {
//            UserModel.userList[key]?.nicknameImage = userImage[count]
//            count += 1
//        }
    }
    
    //MARK: 마커 클릭 이벤트
    func didMarkerClicked() {
        tokenWithMarker.keys.map { key in
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
    
    //MARK: 내위치 카메라 세팅
    @objc func toMyLocation() {
        
        if cameraTrakingToggleFlag && cameraTrakingModeFlag {
            var moveCameraWithZoomAndPosition =  NMFCameraUpdate(scrollTo: NMGLatLng(lat: myLatitude, lng: myLongitude), zoomTo: 16)
//            moveCameraWithZoomAndPosition.animation = .easeOut
//            moveCameraWithZoomAndPosition.animationDuration = 0.2
            mapView.moveCamera(moveCameraWithZoomAndPosition)
        }
    }
    
    @objc func toWholeLocation() {
        if cameraTrakingToggleFlag && cameraTrakingModeFlag == false {
            var minLatLng = NMGLatLng(lat: 150, lng: 150)
            var maxLatLng = NMGLatLng(lat: 0, lng: 0)
            var resultZoomLevel: Double = 0
            
            UserModel.userList.keys.forEach {
                guard (UserModel.userList[$0]!.state = true) != nil else { return }
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
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLngBounds(southWest: minLatLng, northEast: maxLatLng).center)
            var zoomInit = NMFCameraUpdate(zoomTo: 18)
            mapView.moveCamera(cameraUpdate)
            mapView.moveCamera(zoomInit)
            
            while mapView.zoomLevel > 1 {
                let count = UserModel.userList.count
                var trueCount = 0
                UserModel.userList.keys.forEach {
                    let targetPoint = NMGLatLng(lat: UserModel.userList[$0]!.latitude, lng: UserModel.userList[$0]!.longitude)
                    if NMGLatLngBounds(southWest: mapView.projection.latlng(from: CGPoint(x: 0, y: UIScreen.main.bounds.height)), northEast: mapView.projection.latlng(from: CGPoint(x: UIScreen.main.bounds.width, y: 0))).hasPoint(targetPoint) {
                        trueCount += 1
                    }
                }
                if trueCount == count {
                    break
                } else {
                    trueCount = 0
                    mapView.zoomLevel -= 0.05
                }
            }
            resultZoomLevel =  mapView.zoomLevel - 0.2
            var moveCameraWithZoomAndPosition =  NMFCameraUpdate(scrollTo: NMGLatLngBounds(southWest: minLatLng, northEast: maxLatLng).center, zoomTo: resultZoomLevel)
//            if cameraTrakingModeFlag == false {
//                moveCameraWithZoomAndPosition.animation = .easeOut
//                moveCameraWithZoomAndPosition.animationDuration = 0.2
//            }
            mapView.moveCamera(moveCameraWithZoomAndPosition)
        }
    }
    
    @objc func didMyLocationButtonClicked(_ sender: UIButton) {
        multipartPath.mapView = nil
        cameraTrakingToggleFlag = true
        [myLocationButton, bottomSheet.view, bottomTabView].forEach {
            $0?.alpha = 0
            $0?.isHidden = true
        }
        if cameraState.currentImage == UIImage(named: "forest") {
            cameraTrakingModeFlag = true
            sender.tag == 1 ? cameraState.setImage(#imageLiteral(resourceName: "tree"), for: .normal) : cameraTrakingModeFlag.toggle()
            sender.tag == 1 ? toMyLocation() : toWholeLocation()
            
        } else {
            cameraTrakingModeFlag = false
            sender.tag == 1 ? cameraState.setImage(#imageLiteral(resourceName: "forest"), for: .normal) : cameraTrakingModeFlag.toggle()
            sender.tag == 1 ? toWholeLocation() : toMyLocation()
        }
    }
    
    //MARK: 채팅창 클릭
    @objc func testGestureFunc() {
        let view = ChattingViewController()
        present(view, animated: true)
        self.view.bringSubviewToFront(bottomTabView)
        bottomTabView.bringSubviewToFront(self.view)
    }
    
    //MARK: 임시 토글 버튼 액션
    @objc func didtempToggleButtonClicked() {
        locationSocket.connect()
        imageToNameFlag.toggle()
        marking()
        bottomSheet.runningTimeController.collectionView.reloadData()
    }
    
    //MARK: 바텀탭 버튼 클릭
    @objc func didClickecBottomTabButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.bottomSheet.chatViewController.view.isHidden = false
            self.bottomSheet.rankingViewController.view.isHidden = true
            self.bottomSheet.runningTimeController.view.isHidden = true
            UIView.animate(withDuration: 0.15) {
                self.bottomSheet.view.frame = CGRect(x: 0, y: MannaDemo.convertHeigt(value: 525), width: self.view.frame.width, height: self.view.frame.height)
            }
            break
        case 1:
            self.bottomSheet.chatViewController.view.isHidden = true
            self.bottomSheet.rankingViewController.view.isHidden = false
            self.bottomSheet.runningTimeController.view.isHidden = true
            
            disconnectToggleFlag.toggle()
            if bottomTabView.runningTime.currentImage == #imageLiteral(resourceName: "man") {
                bottomTabView.runningTime.setImage(#imageLiteral(resourceName: "women"), for: .normal)
            } else {
                bottomTabView.runningTime.setImage(#imageLiteral(resourceName: "man"), for: .normal)
            }
            UIView.animate(withDuration: 0.15) {
                self.bottomSheet.view.frame = CGRect(x: 0, y: MannaDemo.convertHeigt(value: 470), width: self.view.frame.width, height: self.view.frame.height)
            }
            break
        case 2:
            self.bottomSheet.chatViewController.view.isHidden = true
            self.bottomSheet.rankingViewController.view.isHidden = true
            self.bottomSheet.runningTimeController.view.isHidden = false
            UIView.animate(withDuration: 0.15) {
                self.bottomSheet.view.frame = CGRect(x: 0, y: MannaDemo.convertHeigt(value: 470), width: self.view.frame.width, height: self.view.frame.height)
            }
            break
        default:
            break
        }
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
        let state = UIApplication.shared.applicationState
        if state == .background {
            bottomSheet.rankingViewController.animationView.pause()
        }else if state == .active {
            bottomSheet.rankingViewController.animationView.play()
        }
    }   
}
//extension MapViewController: WebSocketDelegate {
//    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
//        print("\(data)")
//    }
//
//    func websocketDidConnect(socket: WebSocketClient) {
//        print("sockect Connect!")
//        UserModel.userList[MannaDemo.myUUID!]?.state = true
//        setCollcetionViewItem()
//        bottomSheet.runningTimeController.collectionView.reloadData()
//    }
//
//    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
//        print("sockect Disconnect ㅠㅠ")
//        UserModel.userList[MannaDemo.myUUID!]?.state = false
//        setCollcetionViewItem()
//        bottomSheet.runningTimeController.collectionView.reloadData()
//    }
//
//    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        var type: String?
//        var deviceToken: String?
//        var username: String?
//        var lat_: Double?
//        var lng_: Double?
//        let json = text
//
//        if let data = json.data(using: .utf8) {
//
//            //누가 보냈는지
//            if let json = try? JSON(data) ["sender"] {
//                deviceToken = json["deviceToken"].string
//                username = json["username"].string
//            }
//
//            //타입은 무엇이고
//            if let json = try? JSON(data) ["type"] {
//                guard let temp = json.string else { return }
//                type = temp
//            }
//            guard let token = deviceToken else { return }
//            //타입에 따른 처리
//            switch type {
//
//            case "LOCATION" :
//                if let json = try? JSON(data) ["location"] {
//                    lat_ = json["latitude"].double
//                    lng_ = json["longitude"].double
//                    UserModel.userList[token]?.state = true
//                }
//
//            case "LEAVE" :
//
//                guard let name = username else { return }
//                //                UserModel.userList[token]?.state = false
//                UserModel.userList[token]?.networkValidTime = 61
//                marking()
//                setCollcetionViewItem()
//                bottomSheet.runningTimeController.collectionView.reloadData()
//                showToast(message: "\(name)님 나가셨습니다.")
//
//            case "JOIN" :
//                guard let name = username else { return }
//                UserModel.userList[token]?.state = true
//                UserModel.userList[token]?.networkValidTime = 0
//                marking()
//                showToast(message: "\(name)님 접속하셨습니다.")
//                setCollcetionViewItem()
//                bottomSheet.runningTimeController.collectionView.reloadData()
//
//            case .none:
//                print("none")
//
//            case .some(_):
//                print("some")
//            }
//
//            guard let lat = lat_ else { return }
//            guard let lng = lng_ else { return }
//            guard UserModel.userList[token] != nil else { return }
//
//            UserModel.userList[token]?.networkValidTime = 0
//            if token != MannaDemo.myUUID {
//                //마커로 이동하기 위해 저장 멤버의 가장 최근 위치 저장
//                UserModel.userList[token]?.latitude = lat
//                UserModel.userList[token]?.longitude = lng
//            }
//            setCollcetionViewItem()
//            bottomSheet.runningTimeController.collectionView.reloadData()
//        }
//    }
//}
