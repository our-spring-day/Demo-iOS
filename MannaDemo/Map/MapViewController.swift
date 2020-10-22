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

class MapViewController: UIViewController {
    
    let socket = WebSocket(url: URL(string: "ws://ec2-54-180-125-3.ap-northeast-2.compute.amazonaws.com:40008/ws?token=4")!)
    
    var locationOverlay = NMFMapView().locationOverlay
    var locationManager = CLLocationManager()
    let mapView = NMFMapView()
    var myLatitude: Double = 0
    var myLongitude: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        $0.addTarget(self, action: #selector(test), for: .touchUpInside)
    }
    let information = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "information"), for: .normal)
        $0.frame.size.width = 40
        $0.frame.size.height = 40
        $0.layer.cornerRadius = $0.frame.width / 2
        $0.clipsToBounds = true
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
    }
    
    func layout() {
        view.addSubview(mapView)
        view.addSubview(backButton)
        view.addSubview(information)
        
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
    }
    
    @objc func test() {
        socket.disconnect()
        self.dismiss(animated: true)
    }
    
    @objc func emitLocation() {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        socket.write(string: "\"latitude\":\(myLatitude),\"longitude\":\(myLongitude)")
    }
}

extension MapViewController: NMFMapViewCameraDelegate {
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        myLocation.position = NMGLatLng(lat: locValue.latitude, lng: locValue.longitude)
        myLocation.mapView = mapView
        myLatitude = locValue.latitude
        myLongitude = locValue.longitude
        
    }
    
    
}

extension MapViewController: WebSocketDelegate{
    func websocketDidConnect(socket: WebSocketClient) {
        print("sockect Connect!")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("sockect Disconnect ㅠㅠ")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("\(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("\(data)")
    }
    
}
