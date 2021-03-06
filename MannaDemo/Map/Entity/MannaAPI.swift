//
//  PathAPI.swift
//  MannaDemo
//
//  Created by once on 2020/11/02.
//

import Foundation
import Alamofire
import SwiftyJSON
import NMapsMap
import SwiftKeychainWrapper

class MannaAPI {
    static func getPath(lat: Double, lng: Double, completion: @escaping (TravelData) -> Void) {
        var marker = [NMGLatLng]()
        var _: Int
        var _: Double
        let path = "https://dev.virtualearth.net/REST/V1/Routes/Transit?wp.0=\(lat),\(lng)&wp.1=37.475427,126.980378&timeType=Departure&dateTime=12:30:00PM&output=json&routePathOutput=Points&key=AhK9OnM_5KQLKHrjgCesEyiRMP0nx_Koby3ufRW__-l46f8aB6D4GFmMz7M6sgtO"
        AF.request(path).response { response in
            switch response.result {
                case .success(let value):
                    if let json = JSON(value)["resourceSets"][0]["resources"][0]["routePath"]["line"]["coordinates"].array {
                        for location in json {
                            let loc = NMGLatLng(lat: location[0].double!, lng: location[1].double!)
                            marker.append(loc)
                        }
                    }
                    guard let duration = JSON(value)["resourceSets"][0]["resources"][0]["travelDuration"].int else { return }
                    guard let distance = JSON(value)["resourceSets"][0]["resources"][0]["travelDistance"].double else { return }
                    let result = TravelData(path: marker, duration: duration, distance: distance)
                    completion(result)
            case .failure( _):
                    print("error")
            }
        }
    }
    
    static func getChat(mannaID: String, completion: @escaping ([ChatMessage]) -> ()) {
        AF.request("https://manna.duckdns.org:18888/manna/\(mannaID)/chat?deviceToken=\(MannaDemo.myUUID!)").response { response in
            var result: [ChatMessage] = []
            switch response.result {
            case .success(let value):
                if let json = JSON(value).array {
                    for chat in json {
                        let chatPiece = ChatMessage(user: chat["sender"]["username"].string!,
                                                    text: chat["message"].string!,
                                                    timeStamp: chat["createTimestamp"].int!,
                                                    isIncoming: chat["sender"]["deviceToken"].string! == MannaDemo.myUUID ? .me : .other,
                                    sendState: false)
                        result.append(chatPiece)
//                        print("채팅",chatPiece)
                    }
                }
                result.sort(by: { $0.timeStamp < $1.timeStamp })
                completion(result)
                break
            case .failure(let err):
//                print(err)
                break
            }
        }
    }
    
    static func registerPushToken(pushToken: String) {
        guard let deviceID = KeychainWrapper.standard.string(forKey: "device_id") else { return }
        let url = "https://manna.duckdns.org:18888/user/pushToken?deviceToken=\(deviceID)"

        let params: Parameters = [
            "pushToken" : pushToken,
            "type" : "apns"
        ]
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("성공 : ",value)
            case .failure(let err):
                print("에러 : ",err)
            }
        }
    }
    
    static func urgeUser(userName: String) {
        guard let deviceID = KeychainWrapper.standard.string(forKey: "device_id") else { return }
        let userToken = getDeviceToken.getUserDeviceToken(name: userName)
//        print("deviceID : 쏘는 사람 = ",deviceID)
//        print("userToken : 받는 사람 = ",userToken)
        let url = "https://manna.duckdns.org:18888/manna/96f35135-390f-496c-af00-cdb3a4104550/push/\(userToken)?deviceToken=\(deviceID)"
         
        AF.request(url, method: .post).responseString { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
        }
    }
}

