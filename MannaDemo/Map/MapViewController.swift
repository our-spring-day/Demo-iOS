//
//  MapViewController.swift
//  MannaDemo
//
//  Created by once on 2020/10/21.
//

import UIKit
import NMapsMap
import CoreLocation
import Starscream
import SwiftyJSON
import Lottie

protocol test {
    var chatView: UIView? { get set}
}
extension MapViewController: test {
    
}

class MapViewController: UIViewController{
    let userName: [String] = ["우석", "연재", "상원", "재인", "효근", "규리", "종찬", "용권"]
    var userImage: [UIImage] = []
    var chatView: UIView?
    let socket = WebSocket(url: URL(string: "ws://ec2-54-180-125-3.ap-northeast-2.compute.amazonaws.com:40008/ws?token=\(MannaDemo.myUUID!)")!)
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
    var cameraStateFlag = true
    var goalMarker = NMFMarker()
    
    
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
        chatView = bottomSheet.chatViewController.backgroundView
        myLocationButton.isHidden = true
        if socket.isConnected == false {
            socket.connect()
        }
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeChecker), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(marking), userInfo: nil, repeats: true)
        array()
        layout()
        didMarkerClicked()
        attribute()
        bottomSheet.runningTimeController.collectionView.reloadData()
    }
    
    func attribute() {
        socket.do {
            $0.delegate = self
        }
        backButton.do {
            $0.setImage(#imageLiteral(resourceName: "back"), for: .normal)
            $0.frame.size.width = 40
            $0.frame.size.height = 40
            $0.layer.cornerRadius = $0.frame.width / 2
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(back), for: .touchUpInside)
            //            $0.dropShadow()
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
        }
        bottomTabView.do {
            $0.backgroundColor = .white
            $0.chat.addTarget(self, action: #selector(didClickecBottomTabButton), for: .touchUpInside)
            $0.runningTime.addTarget(self, action: #selector(didClickecBottomTabButton), for: .touchUpInside)
            $0.ranking.addTarget(self, action: #selector(didClickecBottomTabButton), for: .touchUpInside)
        }
        cameraState.do {
            $0.setImage(#imageLiteral(resourceName: "forest"), for: .normal)
            $0.addTarget(self, action: #selector(didCameraStateButtonClicked), for: .touchUpInside)
            $0.imageEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.dropShadow()
        }
        myLocationButton.do {
            $0.setImage(#imageLiteral(resourceName: "mylocation"), for: .normal)
            $0.addTarget(self, action: #selector(didMyLocationButtonClicked), for: .touchUpInside)
            $0.imageEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        }
        goalMarker.do {
            $0.iconImage = NMFOverlayImage(image: #imageLiteral(resourceName: "goal"))
            $0.height = MannaDemo.convertWidth(value: 48)
            $0.width = MannaDemo.convertWidth(value: 48)
            $0.position = NMGLatLng(lat: 37.475427, lng: 126.980378)
            $0.mapView = mapView
        }
    }
    
    func layout() {
        [mapView, cameraState, myLocationButton, backButton, timerView, bottomSheet.view, bottomTabView, toastLabel, ].forEach { view.addSubview($0) }
        
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
    
    func array() {
        UserModel.userList.keys.map { tokenWithMarker[$0] = NMFMarker()}
        for marker in tokenWithMarker.values {
            marker.width = MannaDemo.convertWidth(value: 5)
            marker.height = MannaDemo.convertWidth(value: 5)
        }
    }
    
    func renderImage() {
        for name in userName {
            let image = UserView(text: name).then({
                $0.layer.cornerRadius = 30
            })
            let renderImage = image.asImage()
            userImage.append(renderImage)
        }
    }
    
    func nicknameImageSet() {
        var count = 0
        for key in UserModel.userList.keys {
            UserModel.userList[key]?.nicknameImage = userImage[count]
            count += 1
        }
    }
    
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
    
    func setCollcetionViewItem() {
        userListForCollectionView = Array(UserModel.userList.values)
        userListForCollectionView.sort { $0.state && !$1.state}
    }
    
    func camereUpdateOnlyOnce() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: myLatitude, lng: myLongitude))
        mapView.zoomLevel = 10
        mapView.moveCamera(cameraUpdate)
    }
    
    func showToast(message: String) {
        self.toastLabel.text = message
        self.toastLabel.alpha = 1
        UIView.animate(withDuration: 1.5) {
            self.toastLabel.alpha = 0
        } completion: { _ in
        }
    }
    
    @objc func didMyLocationButtonClicked() {
        self.myLocationButton.alpha = 0
        myLocationButton.isHidden = true
        mapView.positionMode = .direction
        multipartPath.mapView = nil
        let zoom = NMFCameraUpdate(zoomTo: 15)
        zoom.animationDuration = 0.5
        [zoom].forEach { mapView.moveCamera($0) }
    }
    
    @objc func didCameraStateButtonClicked() {
        self.myLocationButton.alpha = 0
        myLocationButton.isHidden = true
        
        if cameraState.currentImage == UIImage(named: "forest") {
            cameraState.setImage(#imageLiteral(resourceName: "tree"), for: .normal)
            mapView.positionMode = .direction
            let zoom = NMFCameraUpdate(zoomTo: 15)
            zoom.animationDuration = 0.5
            [zoom].forEach { mapView.moveCamera($0) }
        } else {
            cameraState.setImage(#imageLiteral(resourceName: "forest"), for: .normal)
            
            var minLatLng = NMGLatLng(lat: 150, lng: 150)
            var maxLatLng = NMGLatLng(lat: 0, lng: 0)
            
            
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
            mapView.moveCamera(cameraUpdate)
            
            
            mapView.zoomLevel = 18
            while mapView.zoomLevel > 1 {
                var count = UserModel.userList.count
                var trueCount = 0
                UserModel.userList.keys.forEach {
                    
                    let targetPoint = NMGLatLng(lat: UserModel.userList[$0]!.latitude, lng: UserModel.userList[$0]!.longitude)
//                    print(NMGLatLngBounds(southWest: minLatLng, northEast: maxLatLng).hasPoint(targetPoint))
//                    print(mapView.projection.latlng(from: CGPoint(x: 0, y: UIScreen.main.bounds.height)))
//                    print(mapView.projection.latlng(from: CGPoint(x: UIScreen.main.bounds.width, y: 0)))
                    if NMGLatLngBounds(southWest: mapView.projection.latlng(from: CGPoint(x: 0, y: UIScreen.main.bounds.height)), northEast: mapView.projection.latlng(from: CGPoint(x: UIScreen.main.bounds.width, y: 0))).hasPoint(targetPoint) {
                        trueCount += 1
                    }
                }
                print(trueCount)
                if trueCount == count {
                    break
                } else {
                    trueCount = 0
                    mapView.zoomLevel -= 0.05
                }
            }
            print(mapView.zoomLevel)
            mapView.moveCamera(cameraUpdate)
        }
    }
    
    @objc func testGestureFunc() {
        let view = ChattingViewController()
        view.transitioningDelegate = bottomSheet.chatViewController
        
        let xScaleFactor = bottomSheet.view.frame.width / self.view.frame.width
        let yScaleFactor = bottomSheet.view.frame.height / self.view.frame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        bottomSheet.view.transform = scaleTransform

        bottomSheet.view.center = CGPoint(
            x:  bottomSheet.view.frame.midX,
            y:  bottomSheet.view.frame.midY)
            
        bottomSheet.view.clipsToBounds = true
        UIView.animate(
            withDuration: 0.8,
          delay:0.0725,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1,
            animations: { [self] in
            bottomSheet.view.alpha = 0.3
            self.bottomSheet.view.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY)
            self.bottomSheet.view.layer.cornerRadius = 20.0
          },completion: { _ in
            self.bottomSheet.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 0.64, width: self.view.frame.width, height: self.view.frame.height)
            self.bottomSheet.view.alpha = 1
          }
        )
        present(view, animated: true)
        self.view.bringSubviewToFront(bottomTabView)
        bottomTabView.bringSubviewToFront(self.view)
    }
    
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
            
            //임시!! 토글
            imageToNameFlag.toggle()
            bottomSheet.runningTimeController.collectionView.reloadData()
            marking()
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
    
    @objc func back() {
        self.dismiss(animated: true)
    }
    
    @objc func cameraUpdateToMyLocation() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: myLatitude, lng: myLongitude))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1.3
        mapView.moveCamera(cameraUpdate)
    }
    
    @objc func marking() {
        for key in UserModel.userList.keys {
            if key == MannaDemo.myUUID {
                break
            }
            let user = UserModel.userList[key]
            
            if imageToNameFlag {
                if user!.networkValidTime > 60 {
                    //연결이 끊겼을 때 닉네임프로필 + 끊긴 이미지
                    tokenWithMarker[key]?.iconImage = NMFOverlayImage(image: UserModel.userList[key]!.disconnectProfileImage)
                } else {
                    tokenWithMarker[key]?.iconImage = NMFOverlayImage(image: UserModel.userList[key]!.nicknameImage)
                }
            } else {
                if user!.networkValidTime > 60 {
                    //여결이 끊겼을 때 사진프로필 + 끊긴 이미지
                    tokenWithMarker[key]?.iconImage = NMFOverlayImage(image: UserModel.userList[key]!.disconnectProfileImage)
                } else {
                    tokenWithMarker[key]?.iconImage = NMFOverlayImage(image: UserModel.userList[key]!.profileImage)
                }
            }
            if (UserModel.userList[key]?.state)! {
                tokenWithMarker[key]?.position = NMGLatLng(lat: UserModel.userList[key]!.latitude, lng: UserModel.userList[key]!.longitude)
                tokenWithMarker[key]?.mapView = mapView
            }
        }
    }
    
    func checkedLocation() {
        let status = CLLocationManager.authorizationStatus()
        print(status)
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








