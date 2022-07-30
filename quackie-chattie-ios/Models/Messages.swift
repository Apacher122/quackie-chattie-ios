//
//  Messages.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/25/22.
//

import Foundation

struct Message: Codable, Hashable {
    var sender: String
    var message_text: String
    var room_name: String
}

extension Message {
    init(from: String, text: String, room: String) {
        self.sender = from
        self.message_text = text
        self.room_name = room
    }
}

struct Send: Codable, Hashable {
    var uName: String
    var content: String
    var rName: String
}

extension Send {
    init(username: String, message: String, roomname: String) {
        self.uName = username
        self.content = message
        self.rName = roomname
    }
}
