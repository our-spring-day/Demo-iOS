//
//  User.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/23.
//

import UIKit

struct User {
    var id: String
    var state: Bool
    var profileImage: UIImage
    var disconnectProfileImage: UIImage
    //temp
    var anotherdisconnectProfileImage: UIImage
    var nicknameImage: UIImage
    var latitude: Double
    var longitude: Double
    var remainDistance: Double
    var ranking: Int
    var networkValidTime: Int
    var remainTime: Int
}
struct UserModel {
    static var userList: [String : User] = [
        "f606564d8371e455" : User(id: "1", state: false, profileImage: #imageLiteral(resourceName: "우석img"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "우석"), latitude: 0, longitude: 0, remainDistance: 0, ranking: 0, networkValidTime: 0, remainTime: 9999999999),
        "aed64e8da3a07df4" : User(id: "2", state: false, profileImage: #imageLiteral(resourceName: "연재img"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "연재"), latitude: 0, longitude: 0, remainDistance: 0, ranking: 0, networkValidTime: 0, remainTime: 9999999999),
        "8F630481-548D-4B8A-B501-FFD90ADFDBA4" : User(id: "3", state: false, profileImage: #imageLiteral(resourceName: "상원img"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "상원"), latitude: 0, longitude: 0, remainDistance: 100, ranking: 0, networkValidTime: 0, remainTime: 9999999999),
        "0954A791-B5BE-4B56-8F25-07554A4D6684" : User(id: "4", state: false, profileImage: #imageLiteral(resourceName: "재인img"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "재인"), latitude: 0, longitude: 0, remainDistance: 100, ranking: 0, networkValidTime: 0, remainTime: 9999999999),
        "8D44FAA1-2F87-4702-9DAC-B8B15D949880" : User(id: "5", state: false, profileImage: #imageLiteral(resourceName: "규리img"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "효근"), latitude: 0, longitude: 0, remainDistance: 100, ranking: 0, networkValidTime: 0, remainTime: 9999999999),
        "2872483D-9E7B-46D1-A2B8-44832FE3F1AD" : User(id: "6", state: false, profileImage: #imageLiteral(resourceName: "default"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "test"), latitude: 0, longitude: 0, remainDistance: 100, ranking: 0, networkValidTime: 0, remainTime: 9999999999),
        "C65CDF73-8C04-4F76-A26A-AE3400FEC14B" : User(id: "7", state: false, profileImage: #imageLiteral(resourceName: "종찬img"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "종찬"), latitude: 0, longitude: 0, remainDistance: 100, ranking: 0, networkValidTime: 0, remainTime: 9999999999),
        "69751764-A224-4923-9844-C61646743D10" : User(id: "8", state: false, profileImage: #imageLiteral(resourceName: "규리img"), disconnectProfileImage: #imageLiteral(resourceName: "invalid2"), anotherdisconnectProfileImage: #imageLiteral(resourceName: "invalid1"), nicknameImage: #imageLiteral(resourceName: "종찬"), latitude: 0
                                                      , longitude: 0, remainDistance: 100, ranking: 0, networkValidTime: 0, remainTime: 9999999999)
    ]
}
