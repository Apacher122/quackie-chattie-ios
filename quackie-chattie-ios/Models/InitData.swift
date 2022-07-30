//
//  InitData.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/26/22.
//

import Foundation

struct InitData: Codable{
    let uName: String
    let uid: String
}

extension InitData {
    init(uName: String, userID: String) {
        self.uName = uName
        self.uid = userID
    }
}
