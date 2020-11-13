//
//  MapPresenter.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/13.
//

import Foundation

class MapPresenter {
    
    func currentRanking(userList: [String : User], completion: @escaping ([User]) -> ()) {
        var currentRanking = [User]()
        UserModel.userList.keys.forEach { (key) in
            MannaAPI.getPath(lat: UserModel.userList[key]!.latitude, lng: UserModel.userList[key]!.longitude) { (travelData) in
                UserModel.userList[key]?.remainDistance = travelData.distance
                UserModel.userList[key]?.remainTime = travelData.duration
                
            }
        }
        currentRanking = Array(UserModel.userList.values)
        currentRanking.sort { $0.remainTime < $1.remainTime }
//        userListForCollectionView.sort { $0.state && !$1.state}
//        userListForCollectionView.sort { $0.remainTime < $1.remainTime }
        completion(currentRanking)
    }
}
