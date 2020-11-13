//
//  MapPresenter.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/13.
//

import Foundation

class MapPresenter {
    
    func currentRanking(userList: [String : User], completion: @escaping ([String : User]) -> ()) {
        var currentRanking = userList
        currentRanking.keys.forEach { (key) in
            if ((currentRanking[key]?.state) != nil) {
                MannaAPI.getPath(lat: currentRanking[key]!.latitude, lng: currentRanking[key]!.longitude) { (travelData) in
                    currentRanking[key]?.remainDistance = travelData.distance
                    print("이게 돌면서", currentRanking[key]?.remainDistance)
                    currentRanking[key]?.remainTime = travelData.duration
                }
            }
        }
        currentRanking.keys.forEach { key in
            print(currentRanking[key]?.name,currentRanking[key]?.remainDistance)
        }
        print("이게 돌고난 후 할당이 안되냐왜 씨ㅡ", currentRanking["0954A791-B5BE-4B56-8F25-07554A4D6684"]?.remainDistance)
        completion(currentRanking)
    }
}
