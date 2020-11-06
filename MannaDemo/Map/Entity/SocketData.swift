//
//  SocketData.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/07.
//

import Foundation

struct SocketData: Codable {
    let type: String
    let sender: Sender
    let location: Location?
}
struct Location: Codable {
    let latitude, longitude: Double
}
struct Sender: Codable {
    let deviceToken, username: String
}
