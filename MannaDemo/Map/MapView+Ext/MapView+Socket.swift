//
//  MapView+Socket.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/06.
//

import Foundation
import Starscream
import SwiftyJSON

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
