//
//  Manna.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/10/21.
//

import UIKit

struct Manna {
    var time: String
    var name: String
}

struct NewManna: Codable {
    var mannaname : String
    var createTimestamp : Int
    var chatJoinUserList : [String]?
    var uuid : String
    var locationJoinUserList : String?
}
