//
//  ChatMessage.swift
//  MannaDemo
//
//  Created by once on 2020/11/03.
//

import Foundation

struct ChatMessage {
    let user: String
    var text: String
    let timeStamp: Int
    let isIncoming: UserState
    var sendState: Bool
}
