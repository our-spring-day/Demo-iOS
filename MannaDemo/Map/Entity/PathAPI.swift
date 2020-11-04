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
    static func getPath(lat: Double, lng: Double, completion: @escaping ([NMGLatLng]) -> Void) {
        var marker = [NMGLatLng]()
        let path = "https://dev.virtualearth.net/REST/V1/Routes/Transit?wp.0=\(lat),\(lng)&wp.1=37.475427,126.980378&timeType=Departure&dateTime=1:30:00AM&output=json&routePathOutput=Points&key=AhK9OnM_5KQLKHrjgCesEyiRMP0nx_Koby3ufRW__-l46f8aB6D4GFmMz7M6sgtO"
        AF.request(path).response { response in
            switch response.result {
                case .success(let value):
                    if let json = JSON(value)["resourceSets"][0]["resources"][0]["routePath"]["line"]["coordinates"].array {
                        for location in json {
                            let loc = NMGLatLng(lat: location[0].double!, lng: location[1].double!)
                            marker.append(loc)
                        }
                        completion(marker)
                    }
                case .failure(let _):
                    print("error")
            }
        }
    }
}


