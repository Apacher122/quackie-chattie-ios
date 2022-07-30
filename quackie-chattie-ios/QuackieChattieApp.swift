//
//  QuackieChattieApp.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/26/22.
//

import Foundation
import SwiftUI
import Firebase
import GoogleSignIn

@main
struct QuackieChattieApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var viewModel = AuthenticationViewModel()
    let store = AppStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(store)
        }
    }
}

