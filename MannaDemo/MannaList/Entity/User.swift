//
//  User.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/23.
//

import UIKit

struct User {
    var id: String
    var profileImage: UIImage
    var nicknameImage: UIImage
    var latitude: Double
    var longitude: Double
}
//var user: [String] = ["우석", "연재", "상원", "재인", "효근", "규리", "종찬", "용권"]
class UserModel {
    static var userList: [User] = [
        User(id: "1", profileImage: #imageLiteral(resourceName: "Image-1"), nicknameImage: #imageLiteral(resourceName: "우석"), latitude: 0, longitude: 0),
        User(id: "2", profileImage: #imageLiteral(resourceName: "Image-4"), nicknameImage: #imageLiteral(resourceName: "연재"), latitude: 0, longitude: 0),
        User(id: "3", profileImage: #imageLiteral(resourceName: "Image-2"), nicknameImage: #imageLiteral(resourceName: "상원"), latitude: 0, longitude: 0),
        User(id: "4", profileImage: #imageLiteral(resourceName: "Image"), nicknameImage: #imageLiteral(resourceName: "재인"), latitude: 0, longitude: 0),
        User(id: "5", profileImage: #imageLiteral(resourceName: "Image-3"), nicknameImage: #imageLiteral(resourceName: "효근"), latitude: 0, longitude: 0),
        User(id: "6", profileImage: #imageLiteral(resourceName: "Image-5"), nicknameImage: #imageLiteral(resourceName: "규리"), latitude: 0, longitude: 0),
        User(id: "7", profileImage: #imageLiteral(resourceName: "Image-4"), nicknameImage: #imageLiteral(resourceName: "종찬"), latitude: 0, longitude: 0),
        User(id: "8", profileImage: #imageLiteral(resourceName: "Image-2"), nicknameImage: #imageLiteral(resourceName: "용권"), latitude: 0, longitude: 0)
    ]
}
