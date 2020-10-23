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

class MapViewController: UIViewController {
    let socket = WebSocket(url: URL(string: "ws://ec2-54-180-125-3.ap-northeast-2.compute.amazonaws.com:40008/ws?token=\(MyUUID.uuid!)")!)
    var locationOverlay = NMFMapView().locationOverlay
    var locationManager = CLLocationManager()
    let mapView = NMFMapView()
    var myLocation = NMFMarker().then {
        $0.width = 40
        $0.height = 40
    }
    let backButton = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        $0.frame.size.width = 40
        $0.frame.size.height = 40
        $0.layer.cornerRadius = $0.frame.width / 2
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    let information = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "info"), for: .normal)
        $0.frame.size.width = 40
        $0.frame.size.height = 40
        $0.layer.cornerRadius = $0.frame.width / 2
        $0.clipsToBounds = true
    }
    
    //캡션을 달아야 하기 때문에 이 토큰이 어떤 실제 이름인지 (ex 32412rjklsdjfl -> 정재인 ) 이거를 파싱해서 주던가 아니면 내가 미리 박아버리던가
//    var user: [String] = ["재인", "상원", "우석", "종찬", "용권", "연재", "효근"]
    var user: [String] = ["우석", "연재", "상원", "재인", "효근", "규리", "종찬", "용권"]
    var markers: [NMFMarker] = []
    
    
    var tokenWithIndex: [String : Int] = ["f606564d8371e455" : 0,
                                          "5dcd757a5c7d4c52" : 1,
                                          "8F630481-548D-4B8A-B501-FFD90ADFDBA4" : 2,
                                          "0954A791-B5BE-4B56-8F25-07554A4D6684" : 3,
                                          "4" : 4,
                                          "5" : 5,
                                          "C65CDF73-8C04-4F76-A26A-AE3400FEC14B" : 6,
                                          "7" : 7]
    var myLatitude: Double = 0
    var myLongitude: Double = 0
    var bottomSheet = BottomSheetViewController(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: UIScreen.main.bounds.width,
                                                              height: UIScreen.main.bounds.height * 0.6333))
    var cameraUpdateOnlyOnceFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        array()
        socket.connect()
        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(emitLocation), userInfo: nil, repeats: true)
        bottomSheet.collectionView.reloadData()
        socket.connect()
        attribute()
        layout()
        socket.delegate = self
    }
    
    func attribute() {
        mapView.do {
            $0.frame = view.frame
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
        }
    }
    
    func layout() {
        view.addSubview(mapView)
        view.addSubview(backButton)
        view.addSubview(information)
        view.addSubview(bottomSheet)
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.leading.equalToSuperview().offset(22)
            $0.width.height.equalTo(40)
        }
        information.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.trailing.equalToSuperview().offset(-22)
            $0.width.height.equalTo(40)
        }
        bottomSheet.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(view.frame.height)
            $0.top.equalTo(UIScreen.main.bounds.height * 0.6333)
        }
    }
    
    @objc func back() {
        socket.disconnect()
        self.dismiss(animated: true)
    }
    
    @objc func emitLocation() {
        socket.write(string: "{\"latitude\":\(myLatitude),\"longitude\":\(myLongitude)}")
    }
    
    func marking(marker: NMFMarker, lat: Double, Lng: Double) {
        marker.position = NMGLatLng(lat: lat, lng: Lng)
        marker.mapView = mapView
    }
    
    func array() {
        for str in user {
            let temp = NMFMarker().then {
                $0.iconImage = NMFOverlayImage(image: UIImage(named: str)!)
                $0.width = 40
                $0.height = 40
            }
            markers.append(temp)
        }
    }
        
        func camereUpdateOnlyOnce() {
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: myLatitude, lng: myLongitude))
            mapView.moveCamera(cameraUpdate)
            
        }
    }
    

extension MapViewController: NMFMapViewCameraDelegate {
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        myLatitude = locValue.latitude
        myLongitude = locValue.longitude
        UserModel.userList[tokenWithIndex[MyUUID.uuid!]!].latitude = myLatitude
        UserModel.userList[tokenWithIndex[MyUUID.uuid!]!].longitude = myLongitude
        myLocation.position = NMGLatLng(lat: myLatitude, lng: myLongitude)
        myLocation.captionText = "나"
        myLocation.iconImage = NMFOverlayImage(image: UserModel.userList[tokenWithIndex[MyUUID.uuid!]!].image)
        myLocation.mapView = mapView
        
        if cameraUpdateOnlyOnceFlag {
            camereUpdateOnlyOnce()
            cameraUpdateOnlyOnceFlag = false
            bottomSheet.collectionView.reloadData()
        }
    }
}

extension MapViewController: WebSocketDelegate {
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("\(data)")
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("sockect Connect!")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("sockect Disconnect ㅠㅠ")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        var deviceToken: String?
        var lat_: Double?
        var lng_: Double?
        let json = text
        
        if let data = json.data(using: .utf8) {
            if let json = try? JSON(data: data)["from"]["deviceToken"] {
                guard let temp = json.string else { return }
                deviceToken = temp
                if deviceToken! == MyUUID.uuid! {
                    print("내꺼는 안줄꺼에요")
                    return
                }
                print("deviceToken : \(deviceToken!)")
            }
            
            if let json = try? JSON(data: data)["message"] {
                if let tmp = json.string {
                    let text = tmp.components(separatedBy: ",")
                    let temp = text[0].components(separatedBy: ":")[1]
                    let temp2 = text[1].components(separatedBy: ":")[1]
                    lat_ = Double(temp)
                    lng_ = Double(temp2.trimmingCharacters(in: ["}"]))
                }
                print("latitude : \(lat_!)")
                print("longitude : \(lng_!)")
            }
            
            guard let token = deviceToken else { return }
            guard let lat = lat_ else { return }
            guard let lng = lng_ else { return }
            guard let tokenWithIndex = tokenWithIndex[token] else { return }
            
            marking(marker: markers[tokenWithIndex], lat: lat, Lng: lng)
            //마커로 이동하기 위해 저장 멤버의 가장 최근 위치 저장
            UserModel.userList[tokenWithIndex].latitude = lat
            UserModel.userList[tokenWithIndex].longitude = lng
            bottomSheet.collectionView.reloadData()
        }
    }
}

extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserModel.userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MannaCollectionViewCell.identifier, for: indexPath) as! MannaCollectionViewCell
        if UserModel.userList[indexPath.row].latitude != 0 {
            cell.profileImage.image = UserModel.userList[indexPath.row].image
            cell.backgroundColor = nil
            cell.isUserInteractionEnabled = true
        } else {
            cell.profileImage.image = #imageLiteral(resourceName: "Image-7")
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: UserModel.userList[indexPath.row].latitude, lng: UserModel.userList[indexPath.row].longitude))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1.2
        mapView.moveCamera(cameraUpdate)
    }
}
