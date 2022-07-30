//
//  ViewRouter.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/26/22.
//

import Foundation
import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentpage: Page = .loginPage
}

enum Page {
    case registerPage
    case loginPage
    case roomsPage
    case chatPage
}

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        switch viewModel.state {
        case .signedIn: RoomsListView()
        case .signedOut: LoginView()
        case .goToChatRoom: ChatRoomView()
        case .goToRoomList: RoomsListView()
        case .firstTimeUser: CreateUserNameView()
        }
    }
}
