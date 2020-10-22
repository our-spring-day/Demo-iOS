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
    static var userList: [User] = []
}
