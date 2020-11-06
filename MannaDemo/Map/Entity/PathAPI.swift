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

class PathAPI {
    static func getPath(lat: Double, lng: Double, completion: @escaping (TravelData) -> Void) {
        var marker = [NMGLatLng]()
        var duration: Int
        var distance: Double
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
                case .failure(let _):
                    print("error")
            }
        }
    }
}

