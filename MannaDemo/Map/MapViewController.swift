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

class MapViewController: UIViewController {
    let socket = WebSocket(url: URL(string: "ws://ec2-54-180-125-3.ap-northeast-2.compute.amazonaws.com:40008/ws?token=\(MannaDemo.myUUID!)")!)
    var locationOverlay = NMFMapView().locationOverlay
    var locationManager = CLLocationManager()
    var tokenWithMarker: [String : NMFMarker] = [:]
    let mapView = NMFMapView()
    let backButton = UIButton()
    let infoButton = UIButton()
    var timerView = UIView()
    var hourglassView = UIImageView()
    var bottomSheet = BottomSheetViewController(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: UIScreen.main.bounds.width,
                                                              height: UIScreen.main.bounds.height * 0.5))
    var cameraUpdateOnlyOnceFlag = true
    var myLatitude: Double = 0
    var myLongitude: Double = 0
    var zoomLevel: Double = 10
    var userListForCollectionView: [User] = Array(UserModel.userList.values)
    var imageToNameFlag = true
    var bottomTabView = BottomTabView()
    
    override func viewDidAppear(_ animated: Bool) {
        if cameraUpdateOnlyOnceFlag {
            camereUpdateOnlyOnce()
            cameraUpdateOnlyOnceFlag = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if socket.isConnected == false {
            socket.connect()
        }
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(emitLocation), userInfo: nil, repeats: true)
        array()
        didMarkerClicked()
        attribute()
        layout()
        bottomSheet.collectionView.reloadData()
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
                
                //여기있슴
//                UserModel.userList[key]?.latitude
//                UserModel.userList[key]?.longitude

//                임의 좌표 두개
                
                
                
                
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
        bottomSheet.do {
            $0.collectionView.delegate = self
            $0.collectionView.dataSource = self
            $0.zoomIn.addTarget(self, action: #selector(didzoomInClicked), for: .touchUpInside)
            $0.zoomOut.addTarget(self, action: #selector(didzoomOutClicked), for: .touchUpInside)
            $0.myLocation.addTarget(self, action: #selector(cameraUpdateToMyLocation), for: .touchUpInside)
        }
        timerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.gray.cgColor
        }
        hourglassView.do {
            $0.image = #imageLiteral(resourceName: "hourglass")
        }
        bottomTabView.do {
            $0.backgroundColor = .white
        }
    }
    
    @objc func back() {
        self.dismiss(animated: true)
    }
    
    @objc func info() {
        imageToNameFlag.toggle()
        bottomSheet.collectionView.reloadData()
        marking()
        //이부분 네이버 맵 로고 없애고 메뉴만들어주면 됩니다~
        //        mapView.showLegalNotice()
        //        mapView.showOpenSourceLicense()
    }
    
    @objc func didzoomInClicked() {
        zoomLevel += 1
        var cameraUpadateToNewZoom = NMFCameraUpdate(zoomTo: zoomLevel)
        cameraUpadateToNewZoom.animation = .easeOut
        mapView.moveCamera(cameraUpadateToNewZoom)
    }
    
    @objc func didzoomOutClicked() {
        zoomLevel -= 1
        var cameraUpadateToNewZoom = NMFCameraUpdate(zoomTo: zoomLevel)
        cameraUpadateToNewZoom.animation = .easeOut
        mapView.moveCamera(cameraUpadateToNewZoom)
    }
    
    @objc func cameraUpdateToMyLocation() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: myLatitude, lng: myLongitude))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1.3
        mapView.moveCamera(cameraUpdate)
    }
    
    func layout() {
        [mapView, backButton, infoButton, bottomSheet, timerView, hourglassView, bottomTabView].forEach { view.addSubview($0) }
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.leading.equalToSuperview().offset(22)
            $0.width.height.equalTo(40)
        }
        infoButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.trailing.equalToSuperview().offset(-22)
            $0.width.height.equalTo(40)
        }
        bottomSheet.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(view.frame.height)
            $0.top.equalTo(UIScreen.main.bounds.height * 0.5)
        }
        timerView.snp.makeConstraints {
            $0.centerX.equalTo(view)
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(MannaDemo.convertHeigt(value: 42.03))
            $0.centerY.equalTo(backButton)
            $0.width.equalTo(MannaDemo.convertWidth(value: 122))
            $0.height.equalTo(MannaDemo.convertHeigt(value: 42))
        }
        hourglassView.snp.makeConstraints {
            $0.centerY.equalTo(backButton.snp.centerY)
            $0.leading.equalTo(timerView.snp.leading).offset(MannaDemo.convertWidth(value: 15))
            $0.width.equalTo(MannaDemo.convertHeigt(value: 25))
            $0.height.equalTo(MannaDemo.convertWidth(value: 20))
        }
        bottomTabView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view)
            $0.height.equalTo(MannaDemo.convertHeigt(value: 70))
        }
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
        let toastLabel = UILabel().then {
            $0.backgroundColor = UIColor.lightGray
            $0.textColor = UIColor.black
            $0.textAlignment = .center
        }
        view.addSubview(toastLabel)
        toastLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 170).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 45).isActive = true
        }
        toastLabel.do {
            $0.text = "\(message)"
            $0.font = UIFont.boldSystemFont(ofSize: 15)
            $0.alpha = 1.0
            $0.layer.cornerRadius = 15
            $0.clipsToBounds = true
        }
        UIView.animate(withDuration: 1.5) {
            toastLabel.alpha = 0.0
        } completion: { _ in
            toastLabel.removeFromSuperview()
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
        bottomSheet.collectionView.reloadData()
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
        bottomSheet.collectionView.reloadData()
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("sockect Disconnect ㅠㅠ")
        UserModel.userList[MannaDemo.myUUID!]?.state = false
        setCollcetionViewItem()
        bottomSheet.collectionView.reloadData()
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
                bottomSheet.collectionView.reloadData()
                showToast(message: "\(name)님 나가셨습니다.")
                
            case "JOIN" :
                guard let name = username else { return }
                UserModel.userList[token]?.state = true
                showToast(message: "\(name)님 접속하셨습니다.")
                setCollcetionViewItem()
                bottomSheet.collectionView.reloadData()
                
            case .none:
                print("none")
                
            case .some(_):
                print("some")
            }
            
            guard let lat = lat_ else { return }
            guard let lng = lng_ else { return }
            guard var user = UserModel.userList[token] else { return }
            
            if token != MannaDemo.myUUID {
                //마커로 이동하기 위해 저장 멤버의 가장 최근 위치 저장
                UserModel.userList[token]?.latitude = lat
                UserModel.userList[token]?.longitude = lng
                marking()
            }
            setCollcetionViewItem()
            bottomSheet.collectionView.reloadData()
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
