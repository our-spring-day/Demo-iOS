//
//  SocketIOManager.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/06.
//

import UIKit
import SocketIO

//struct Location : SocketData {
//   let latitude: Double
//   let longitude: Double
//    
//   func socketRepresentation() -> SocketData {
//       return ["latitude": latitude, "longitude": longitude]
//   }
//}
//
//class SocketIOManager: NSObject {
//    static let shared = SocketIOManager()
//    
////    var manager = SocketManager(socketURL: URL(string: "https://manna.duckdns.org:19999")!, config: [.log(true), .compress, .connectParams(["deviceToken": MannaDemo.myUUID,"mannaID":"96f35135-390f-496c-af00-cdb3a4104550"])])
//    
//    var locationSocket: SocketIOClient!
//    var chatSocket: SocketIOClient!
//    
//    override init() {
//        super.init()
////        locationSocket = self.manager.socket(forNamespace: "/location")
////        chatSocket = self.manager.socket(forNamespace: "/chat")
//        
////        locationSocket.on("location") { (array, ack) in
////            print(array)
////            print(ack)
////        }
////        locationSocket.on("locationConnect") { (array, ack) in
////            UserModel.userList[MannaDemo.myUUID!]?.state = true
////        }
////        locationSocket.on("locationDisconnect") { (array, ack) in
////            print(array)
////            print(ack)
////        }
////        chatSocket.on("chatConnect") { (array, ack) in
////            print(array)
////            print(ack)
////        }
////        chatSocket.on("chatDisconnect") { (array, ack) in
////            print(array)
////            print(ack)
////        }
////        chatSocket.on("chat") { (array, ack) in
////            print(array)
////            print(ack)
////        }
//    }
////    func establishConnection() {
////        locationSocket.connect()
////        chatSocket.connect()
////    }
////    func closeConnection() {
////        locationSocket.disconnect()
////        chatSocket.disconnect()
////    }
////    @objc func sendLocation(latitude: Double, longitude: Double) {
////        locationSocket.emit("location", "{\"latitude\":\(latitude),\"longitude\":\(longitude)}")
////    }
////    @objc func sendChat(message: String) {
////        chatSocket.emit("chat", message)
////    }
//}
