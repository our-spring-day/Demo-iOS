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
        User(id: "1", image: #imageLiteral(resourceName: "재인"), latitude: 0, longitude: 0),
        User(id: "2", image: #imageLiteral(resourceName: "상원"), latitude: 0, longitude: 0),
        User(id: "3", image: #imageLiteral(resourceName: "우석"), latitude: 0, longitude: 0),
        User(id: "4", image: #imageLiteral(resourceName: "종찬"), latitude: 0, longitude: 0),
        User(id: "5", image: #imageLiteral(resourceName: "용권"), latitude: 0, longitude: 0),
        User(id: "6", image: #imageLiteral(resourceName: "연재"), latitude: 0, longitude: 0),
        User(id: "7", image: #imageLiteral(resourceName: "효근"), latitude: 0, longitude: 0)
    ]
}
