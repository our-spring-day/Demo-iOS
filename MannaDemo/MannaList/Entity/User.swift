//
//  User.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/23.
//

import UIKit

struct User {
    var id: String
    var image: UIImage
    var latitude: Double
    var longitude: Double
}

class UserModel {
    static var userList: [User] = [
        User(id: "1", image: #imageLiteral(resourceName: "KakaoTalk_Photo_2020-10-23-17-39-46"), latitude: 0, longitude: 0),
        User(id: "2", image: #imageLiteral(resourceName: "KakaoTalk_Photo_2020-10-23-17-39-50"), latitude: 0, longitude: 0),
        User(id: "3", image: #imageLiteral(resourceName: "KakaoTalk_Photo_2020-10-23-17-39-54"), latitude: 0, longitude: 0),
        User(id: "4", image: #imageLiteral(resourceName: "KakaoTalk_Photo_2020-10-23-17-39-37"), latitude: 0, longitude: 0),
        User(id: "5", image: #imageLiteral(resourceName: "KakaoTalk_Photo_2020-10-23-17-39-57"), latitude: 0, longitude: 0),
        User(id: "6", image: #imageLiteral(resourceName: "KakaoTalk_Photo_2020-10-23-17-40-5"), latitude: 0, longitude: 0),
        User(id: "7", image: #imageLiteral(resourceName: "KakaoTalk_Photo_2020-10-23-17-40-1"), latitude: 0, longitude: 0)
    ]
}
