//
//  User.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/23.
//

import UIKit

struct User {
    var id: String
    var latitude: Double
    var longitude: Double
}

class UserModel {
    static var userList: [User] = [
        User(id: "1", latitude: 36.84117702656697, longitude: 127.18083410291914),
        User(id: "2", latitude: 0, longitude: 0),
        User(id: "3", latitude: 0, longitude: 0),
        User(id: "4", latitude: 0, longitude: 0),
        User(id: "5", latitude: 0, longitude: 0),
        User(id: "6", latitude: 0, longitude: 0)
    ]
}
