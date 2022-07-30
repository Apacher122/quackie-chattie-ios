//
//  SocketHandler.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/23/22.
//

import Foundation
import SocketIO
import FirebaseAuth
import GoogleSignIn
import Combine
import SwiftUI

// A singleton class to manage sockets
// I hate singletons but it makes sense here
class SocketHandler: NSObject {
    static let shared = SocketHandler()
    let manager = SocketManager(socketURL: URL(string: "https://floating-headland-71614.herokuapp.com")!, config: [.log(true), .compress])
    var mSock: SocketIOClient!
    
    override init() {
        super.init()
        mSock = manager.defaultSocket
    }
    
    func establishConnection() {
        mSock.connect()
    }
    
    func closeConnection() {
        mSock.disconnect()
    }
    
    func getSocket() -> SocketIOClient {
        return mSock
    }
}

