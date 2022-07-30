//
//  Rooms.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/25/22.
//

import Foundation

struct Rooms: Codable {
    var room_id: String
    var room_name: String
    var user_name: String
}

extension Rooms {
    init(id: String, name: String, user: String) {
        self.room_id = id
        self.room_name = name
        self.user_name = user
    }
}
