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
        print("커런트랭킹까지 들어온",userList)
        var currentRanking = userList
        
        currentRanking.keys.forEach { (key) in
            if ((currentRanking[key]?.state) != nil) {
                print("포이치 들어온사람",currentRanking[key]?.name)
                MannaAPI.getPath(lat: currentRanking[key]!.latitude, lng: currentRanking[key]!.longitude) { (travelData) in
                    print("여기 나 없냐?",currentRanking[key]?.name)
                    currentRanking[key]?.remainDistance = travelData.distance
                    currentRanking[key]?.remainTime = travelData.duration
                    completion(currentRanking)
                }
            }
        }
        
    }
}
