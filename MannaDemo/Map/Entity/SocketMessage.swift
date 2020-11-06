//
//  SocketMessage.swift
//  MannaDemo
//
//  Created by once on 2020/11/07.
//

import Foundation

struct SocketMessage: Codable {
    let message: Message?
    let sender: Sender
    let type: String?
}

struct Message: Codable {
    let createTimestamp: Int
    let message: String
}

