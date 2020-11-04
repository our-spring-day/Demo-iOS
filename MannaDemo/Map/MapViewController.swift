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
class MapViewController: UIViewController {
    var chatView: UIView?
    
    let socket = WebSocket(url: URL(string: "ws://ec2-54-180-125-3.ap-northeast-2.compute.amazonaws.com:40008/ws?token=\(MannaDemo.myUUID!)")!)
    var locationOverlay = NMFMapView().locationOverlay
    var locationManager = CLLocationManager()
    var tokenWithMarker: [String : NMFMarker] = [:]
    let mapView = NMFMapView()
    let backButton = UIButton()
    let infoButton = UIButton()
    var timerView = UIView()
    var timeLabel = UILabel()
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
    lazy var testGesture = UITapGestureRecognizer(target: self, action: #selector(testGestureFunc))
    
    
    
    @objc func testGestureFunc() {
        let view = tempViewController()
        view.transitioningDelegate = bottomSheet.chatViewController
        bottomSheet.chatViewController.view.alpha = 0.3
        UIView.animate(withDuration: 0, delay: 0.8) {
            self.bottomSheet.chatViewController.view.alpha = 1
        }
        present(view, animated: true)
        self.view.bringSubviewToFront(bottomTabView)
        bottomTabView.bringSubviewToFront(self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if cameraUpdateOnlyOnceFlag {
            camereUpdateOnlyOnce()
            cameraUpdateOnlyOnceFlag = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatView = bottomSheet.chatViewController.backgroundView
        if socket.isConnected == false {
            socket.connect()
        }
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(emitLocation), userInfo: nil, repeats: true)
        array()
        didMarkerClicked()
        attribute()
        layout()
        bottomSheet.runningTimeController.collectionView.reloadData()
    }
    
    func array() {
        UserModel.userList.keys.map { tokenWithMarker[$0] = NMFMarker()}
        for marker in tokenWithMarker.values {
            marker.width = MannaDemo.convertWidth(value: 5)
            marker.height = MannaDemo.convertWidth(value: 5)
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
                        NMGLineString(points: result)
                    ]
                    multipartPath.colorParts = [
                        NMFPathColor(color: UIColor.red, outlineColor: UIColor.white, passedColor: UIColor.gray, passedOutlineColor: UIColor.lightGray)
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
        }
        infoButton.do {
            $0.setImage(#imageLiteral(resourceName: "info"), for: .normal)
            $0.frame.size.width = 40
            $0.frame.size.height = 40
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = $0.frame.width / 2
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(info), for: .touchUpInside)
        }
        mapView.do {
            $0.frame = view.frame
            $0.addCameraDelegate(delegate: self)
            $0.mapType = .navi
            $0.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true)
            $0.symbolScale = 0.85
            $0.logoInteractionEnabled = false
            $0.maxZoomLevel = 18
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
            $0.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 0.5, width: view.frame.width, height: view.frame.height)
            $0.chatViewController.backgroundView.addGestureRecognizer(testGesture)
        }
        timerView.do {
            $0.backgroundColor = UIColor(named: "keyColor")
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
        }
        timeLabel.do {
            $0.textAlignment = .center
            $0.font = UIFont(name: "SFProDisplay-Medium", size: 17)
            $0.text = "59 : 59 : 59"
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
        }
    }
    
    @objc func didCameraStateButtonClicked() {
        if cameraState.currentImage == UIImage(named: "forest") {
            cameraState.setImage(#imageLiteral(resourceName: "tree"), for: .normal)
            let position = NMFCameraUpdate(scrollTo: NMGLatLng(lat: myLatitude, lng: myLongitude))
            position.animation = .easeOut
            position.animationDuration = 0.5
            let zoom = NMFCameraUpdate(zoomTo: 15)
            zoom.animationDuration = 0.5
            [zoom, position].forEach { mapView.moveCamera($0) }
        } else {
            cameraState.setImage(#imageLiteral(resourceName: "forest"), for: .normal)
        }
    }
    
    func layout() {
        [mapView, backButton, infoButton, timerView, bottomSheet.view, bottomTabView, toastLabel, timeLabel, cameraState].forEach { view.addSubview($0) }
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.leading.equalToSuperview().offset(22)
            $0.width.height.equalTo(40)
        }
        infoButton.snp.makeConstraints {
            $0.top.equalTo(cameraState.snp.bottom).offset(100)
            $0.trailing.equalToSuperview().offset(-22)
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
        timeLabel.snp.makeConstraints {
            $0.centerX.centerY.equalTo(timerView)
            $0.width.equalTo(MannaDemo.convertWidth(value: 90))
            $0.height.equalTo(MannaDemo.convertHeigt(value: 45))
        }
        bottomTabView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view)
            $0.height.equalTo(MannaDemo.convertHeigt(value: MannaDemo.convertHeigt(value: 85)))
        }
        cameraState.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.trailing.equalToSuperview().offset(-22)
            $0.width.height.equalTo(40)
        }
    }
    
    @objc func didClickecBottomTabButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.bottomSheet.chatViewController.view.isHidden = false
            self.bottomSheet.runningTimeController.view.isHidden = true
            self.bottomSheet.rankingViewController.view.isHidden = true
            UIView.animate(withDuration: 0.15) {
                self.bottomSheet.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 0.64, width: self.view.frame.width, height: self.view.frame.height)
            }
            break
        case 1:
            self.bottomSheet.chatViewController.view.isHidden = true
            self.bottomSheet.runningTimeController.view.isHidden = false
            self.bottomSheet.rankingViewController.view.isHidden = true
            UIView.animate(withDuration: 0.15) {
                self.bottomSheet.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 0.5, width: self.view.frame.width, height: self.view.frame.height)
            }
            break
        case 2:
            self.bottomSheet.chatViewController.view.isHidden = true
            self.bottomSheet.runningTimeController.view.isHidden = true
            self.bottomSheet.rankingViewController.view.isHidden = false
            UIView.animate(withDuration: 0.15) {
                self.bottomSheet.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 0.5, width: self.view.frame.width, height: self.view.frame.height)
            }
            break
        default:
            break
        }
    }
    
    @objc func back() {
        self.dismiss(animated: true)
    }
    
    @objc func info() {
        imageToNameFlag.toggle()
        bottomSheet.runningTimeController.collectionView.reloadData()
        marking()
    }
    
    @objc func cameraUpdateToMyLocation() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: myLatitude, lng: myLongitude))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1.3
        mapView.moveCamera(cameraUpdate)
    }
    
    @objc func emitLocation() {
        socket.write(string: "{\"latitude\":\(myLatitude),\"longitude\":\(myLongitude)}")
    }
    
    func marking() {
        for key in UserModel.userList.keys {
            if imageToNameFlag {
                tokenWithMarker[key]?.iconImage = NMFOverlayImage(image: UserModel.userList[key]!.nicknameImage)
            } else {
                tokenWithMarker[key]?.iconImage = NMFOverlayImage(image: UserModel.userList[key]!.profileImage)
            }
            if (UserModel.userList[key]?.state)! {
                tokenWithMarker[key]?.position = NMGLatLng(lat: UserModel.userList[key]!.latitude, lng: UserModel.userList[key]!.longitude)
                tokenWithMarker[key]?.mapView = mapView
            }
        }
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
}

extension MapViewController: NMFMapViewCameraDelegate {
    func zoomLinearEquation(zoomLevel: Double) -> CGFloat{
        return  CGFloat(-(25/3) * zoomLevel + 175)
    }
    
    func markerResizeByZoomLevel() {
        if mapView.zoomLevel > 15 {
            tokenWithMarker.map { (key, marker) in
                marker.width = MannaDemo.convertWidth(value: zoomLinearEquation(zoomLevel: mapView.zoomLevel))
                marker.height = MannaDemo.convertWidth(value: zoomLinearEquation(zoomLevel: mapView.zoomLevel))
                marker.mapView = mapView
            }
        } else {
            tokenWithMarker.map { (key, marker) in
                marker.width = MannaDemo.convertWidth(value: 50)
                marker.height = MannaDemo.convertWidth(value: 50)
                marker.mapView = mapView
            }
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        markerResizeByZoomLevel()
    }
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        markerResizeByZoomLevel()
    }
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        markerResizeByZoomLevel()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        myLatitude = locValue.latitude
        myLongitude = locValue.longitude
        UserModel.userList[MannaDemo.myUUID!]?.latitude = myLatitude
        UserModel.userList[MannaDemo.myUUID!]?.longitude = myLongitude
        if imageToNameFlag {
            tokenWithMarker[MannaDemo.myUUID!]?.iconImage = NMFOverlayImage(image: UserModel.userList[MannaDemo.myUUID!]!.nicknameImage)
        } else {
            tokenWithMarker[MannaDemo.myUUID!]?.iconImage = NMFOverlayImage(image: UserModel.userList[MannaDemo.myUUID!]!.profileImage)
        }
        tokenWithMarker[MannaDemo.myUUID!]?.do {
            $0.position = NMGLatLng(lat: myLatitude, lng: myLongitude)
            $0.mapView = mapView
        }
        setCollcetionViewItem()
        bottomSheet.runningTimeController.collectionView.reloadData()
    }
}
extension MapViewController: WebSocketDelegate {
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("\(data)")
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("sockect Connect!")
        UserModel.userList[MannaDemo.myUUID!]?.state = true
        setCollcetionViewItem()
        bottomSheet.runningTimeController.collectionView.reloadData()
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("sockect Disconnect ㅠㅠ")
        UserModel.userList[MannaDemo.myUUID!]?.state = false
        setCollcetionViewItem()
        bottomSheet.runningTimeController.collectionView.reloadData()
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        var type: String?
        var deviceToken: String?
        var username: String?
        var lat_: Double?
        var lng_: Double?
        let json = text
        
        if let data = json.data(using: .utf8) {
            
            //누가 보냈는지
            if let json = try? JSON(data) ["sender"] {
                deviceToken = json["deviceToken"].string
                username = json["username"].string
            }
            
            //타입은 무엇이고
            if let json = try? JSON(data) ["type"] {
                guard let temp = json.string else { return }
                type = temp
            }
            guard let token = deviceToken else { return }
            //타입에 따른 처리
            switch type {
            
            case "LOCATION" :
                if let json = try? JSON(data) ["location"] {
                    lat_ = json["latitude"].double
                    lng_ = json["longitude"].double
                    UserModel.userList[token]?.state = true
                }
                
            case "LEAVE" :
                guard let name = username else { return }
                UserModel.userList[token]?.state = false
                setCollcetionViewItem()
                bottomSheet.runningTimeController.collectionView.reloadData()
                showToast(message: "\(name)님 나가셨습니다.")
                
            case "JOIN" :
                guard let name = username else { return }
                UserModel.userList[token]?.state = true
                showToast(message: "\(name)님 접속하셨습니다.")
                setCollcetionViewItem()
                bottomSheet.runningTimeController.collectionView.reloadData()
                
            case .none:
                print("none")
                
            case .some(_):
                print("some")
            }
            
            guard let lat = lat_ else { return }
            guard let lng = lng_ else { return }
            guard UserModel.userList[token] != nil else { return }
            
            if token != MannaDemo.myUUID {
                //마커로 이동하기 위해 저장 멤버의 가장 최근 위치 저장
                UserModel.userList[token]?.latitude = lat
                UserModel.userList[token]?.longitude = lng
                marking()
            }
            setCollcetionViewItem()
            bottomSheet.runningTimeController.collectionView.reloadData()
        }
    }
}
extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userListForCollectionView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MannaCollectionViewCell.identifier, for: indexPath) as! MannaCollectionViewCell
        let user = userListForCollectionView[indexPath.row]
        let userListCount =  userListForCollectionView.filter { $0.state == true }.count
        
        if indexPath.row == 0 {
            cell.ranking.image = #imageLiteral(resourceName: "🥇")
        } else if indexPath.row ==  userListCount - 1 && indexPath.row != 0 {
            cell.ranking.image = #imageLiteral(resourceName: "☠️")
        } else if userListCount > 2 {
            if indexPath.row == 1 {
                cell.ranking.image = #imageLiteral(resourceName: "🥈")
            } else if indexPath.row == 2 {
                cell.ranking.image = #imageLiteral(resourceName: "🥉")
            } else {
                cell.ranking.image = UIImage()
            }
        } else {
            cell.ranking.image = UIImage()
        }
        
        if user.state {
            if imageToNameFlag {
                cell.profileImage.image = user.nicknameImage
                cell.backgroundColor = nil
                cell.isUserInteractionEnabled = true
            } else {
                cell.profileImage.image = user.profileImage
                cell.backgroundColor = nil
                cell.isUserInteractionEnabled = true
            }
        } else {
            cell.profileImage.image = #imageLiteral(resourceName: "profile")
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if userListForCollectionView[indexPath.row].latitude != 0 && userListForCollectionView[indexPath.row].longitude != 0 {
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: userListForCollectionView[indexPath.row].latitude, lng: userListForCollectionView[indexPath.row].longitude))
            cameraUpdate.animation = .fly
            cameraUpdate.animationDuration = 1.2
            mapView.moveCamera(cameraUpdate)
        }
    }
}
