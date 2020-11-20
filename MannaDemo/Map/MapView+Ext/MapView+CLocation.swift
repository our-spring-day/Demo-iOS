//
//  MapView+CLocation.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/06.
//

import UIKit
import CoreLocation

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        
        myLatitude = locValue.latitude
        myLongitude = locValue.longitude
        rankingViewController!.userList[MannaDemo.myUUID!]?.latitude = locValue.latitude
        rankingViewController!.userList[MannaDemo.myUUID!]?.longitude = locValue.longitude
        
        locationSocket.emit("location", "{\"latitude\":\(locValue.latitude),\"longitude\":\(locValue.longitude)}")
        
    }
    
    // MARK: 위치권한 다시 받는곳
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != CLAuthorizationStatus.authorizedAlways {
            //위치권한 거부되있을 경우
            let alter = UIAlertController(title: "위치권한 설정을 항상으로 해주셔야 합니다.", message: "앱 설정 화면으로 가시겠습니까? \n '아니오'를 선택하시면 앱이 종료됩니다.", preferredStyle: UIAlertController.Style.alert)
            let logOkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default) {
                (action: UIAlertAction) in
                UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
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
}
