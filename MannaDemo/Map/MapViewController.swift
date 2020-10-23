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
    var tempMarker: NMFMarker?
    //서버에 내 uuid 입력 되면 주석처리 된걸로 써야 함
    let socket = WebSocket(url: URL(string: "ws://ec2-54-180-125-3.ap-northeast-2.compute.amazonaws.com:40008/ws?token=\(MyUUID.uuid!)")!)
    //    let socket = WebSocket(url: URL(string: "ws://ec2-54-180-125-3.ap-northeast-2.compute.amazonaws.com:40008/ws?token=3")!)
    var locationOverlay = NMFMapView().locationOverlay
    var locationManager = CLLocationManager()
    let mapView = NMFMapView()
    var myLocation = NMFMarker().then {
        $0.width = 30
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
    var user: [String] = ["상원", "재인", "우석", "종찬", "연재", "용권", "효근"]
    var markers: [NMFMarker] = []
    
    var tokenWithIndex: [String : Int] = ["8F630481-548D-4B8A-B501-FFD90ADFDBA4": 0,
                                          "0954A791-B5BE-4B56-8F25-07554A4D6684": 1,
                                          "f606564d8371e455": 2]
    var myLatitude: Double = 0
    var myLongitude: Double = 0
    var bottomSheet = BottomSheetViewController(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: UIScreen.main.bounds.width,
                                                              height: UIScreen.main.bounds.height/2))
    override func viewDidLoad() {
        super.viewDidLoad()
        array()
        socket.connect()
        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(emitLocation), userInfo: nil, repeats: true)
        //        카메라 첫 시점 세팅
        //        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: $0.currentLocation.lat, lng: $0.currentLocation.lng))
        //        cameraUpdate.animation = .easeOut
        //        mapView.moveCamera(cameraUpdate)
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
            $0.backgroundColor = .white
            $0.alpha = 0.9
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
            $0.centerY.equalTo(view.frame.maxY)
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
}

extension MapViewController: NMFMapViewCameraDelegate {
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        myLatitude = locValue.latitude
        myLongitude = locValue.longitude
        myLocation.position = NMGLatLng(lat: myLatitude, lng: myLongitude)
        myLocation.mapView = mapView
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
        }
    }
}
