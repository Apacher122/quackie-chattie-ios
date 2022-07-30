//
//  AppStore.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/27/22.
//

import Foundation
import SwiftUI

class AppStore: ObservableObject {
    struct AppState {
        let chatService: ChatService
    }
    
    @Published private(set) var state = AppState(chatService: ChatService())
}
