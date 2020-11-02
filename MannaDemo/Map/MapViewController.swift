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

//let animationView = AnimationView(name:"17338-go-fix")
//
////메인 뷰에 삽입
//view.addSubview(animationView)
//animationView.frame = animationView.superview!.bounds
//animationView.contentMode = .scaleAspectFit
//
////애니메이션 재생(애니메이션 재생모드 미 설정시 1회)
//animationView.play()
//
////애니메이션 재생모드( .loop = 애니메이션 무한재생)
//animationView.loopMode = .loop
//
////애니메이션 종료
////animationView.pause()
//[출처] 스위프트[Swift] - Lottie 사용법|작성자 홍군


class MapViewController: UIViewController {
    let socket = WebSocket(url: URL(string: "ws://ec2-54-180-125-3.ap-northeast-2.compute.amazonaws.com:40008/ws?token=\(MannaDemo.myUUID!)")!)
    var locationOverlay = NMFMapView().locationOverlay
    var locationManager = CLLocationManager()
    let mapView = NMFMapView()
    var myLocation = NMFMarker().then {
        $0.width = MannaDemo.convertWidth(value: 50)
        $0.height = MannaDemo.convertWidth(value: 50)
    }
    let backButton = UIButton()
    let infoButton = UIButton()
    var zoomLevel: Double = 10
    var markers: [NMFMarker] = []
    var tokenWithMarker: [String : NMFMarker] = [:]
    var userListForCollectionView: [User] = Array(UserModel.userList.values)
    var animationView = AnimationView(name:"12670-flying-airplane")
    var myLatitude: Double = 0
    var myLongitude: Double = 0
    var bottomSheet = BottomSheetViewController(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: UIScreen.main.bounds.width,
                                                              height: UIScreen.main.bounds.height * 0.55))
    var cameraUpdateOnlyOnceFlag = true
    var imageToNameFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        array()
        didMarkerClicked()
        if socket.isConnected == false {
            socket.connect()
        }
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(emitLocation), userInfo: nil, repeats: true)
        bottomSheet.collectionView.reloadData()
        attribute()
        layout()
        socket.delegate = self
        mapView.addCameraDelegate(delegate: self)
        lottieFunc()
    }
    func setCollcetionViewItem() {
        userListForCollectionView = Array(UserModel.userList.values)
        userListForCollectionView.sort { $0.state && !$1.state}
    }
    
    func lottieFunc() {
        view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalTo(bottomSheet.backgroundView)
            $0.width.height.equalTo(75)
        }
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.loopMode = .loop
        //animationView.pause()
    }
    
    func attribute() {
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
            $0.mapType = .navi
            $0.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true)
            $0.symbolScale = 0.85
            $0.logoInteractionEnabled = false
            $0.logoAlign = NMFLogoAlign(rawValue: 10)!
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
        [mapView, backButton, infoButton, bottomSheet].forEach { view.addSubview($0) }
        
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
            $0.top.equalTo(UIScreen.main.bounds.height * 0.55)
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
    
    func didMarkerClicked() {
        tokenWithMarker.keys.map { key in
            tokenWithMarker[key]?.touchHandler = { [self] (overlay: NMFOverlay) -> Bool in
                mapView.zoomLevel = 10
                let lat = UserModel.userList[key]?.latitude
                let lng = UserModel.userList[key]?.longitude
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat!, lng: lng!))
                cameraUpdate.animation = .fly
                cameraUpdate.animationDuration = 0.8
                mapView.moveCamera(cameraUpdate)
                 
                return true
            }
        }
    }
    
    func array() {
        UserModel.userList.keys.map { tokenWithMarker[$0] = NMFMarker()}
        
        for marker in tokenWithMarker.values {
            marker.width = MannaDemo.convertWidth(value: 50)
            marker.height = MannaDemo.convertWidth(value: 50)
        }
    }
    
    func camereUpdateOnlyOnce() {
        mapView.zoomLevel = 10
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: myLatitude, lng: myLongitude))
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
        
        if cameraUpdateOnlyOnceFlag {
            camereUpdateOnlyOnce()
            cameraUpdateOnlyOnceFlag = false
        }
        
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
        //        userListForCollectionView = Array(UserModel.userList.values)
        setCollcetionViewItem()
        bottomSheet.collectionView.reloadData()
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("sockect Disconnect ㅠㅠ")
        UserModel.userList[MannaDemo.myUUID!]?.state = false
        //        userListForCollectionView = Array(UserModel.userList.values)
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
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: userListForCollectionView[indexPath.row].latitude, lng: userListForCollectionView[indexPath.row].longitude))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1.2
        mapView.moveCamera(cameraUpdate)
    }
}
