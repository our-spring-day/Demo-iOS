//
//  MapPresenter.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/13.
//

import Foundation
import NMapsMap

class MapPresenter {
    
    func currentRanking(userList: [String : User], completion: @escaping ([String : User]) -> ()) {
        var currentRanking = userList
        
        currentRanking.keys.forEach { (key) in
            if ((currentRanking[key]?.state) != nil) {
                MannaAPI.getPath(lat: currentRanking[key]!.latitude, lng: currentRanking[key]!.longitude) { (travelData) in
                    currentRanking[key]?.remainDistance = travelData.distance
                    currentRanking[key]?.remainTime = travelData.duration
                    completion(currentRanking)
                }
            }
        }
        
    }
}
