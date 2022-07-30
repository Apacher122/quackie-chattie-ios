//
//  FireBaseAuthentication.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/26/22.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase
import SwiftUI
import SocketIO
class AuthenticationViewModel: ObservableObject {
    enum LogInState {
        case signedIn
        case signedOut
        case goToChatRoom
        case goToRoomList
        case firstTimeUser
    }
    
    @Published var state: LogInState = .signedOut
    @Published var room_name: String = ""
    
    func goToRooms() {
        state = .goToRoomList
    }
    
    func firstTime() {
        state = .firstTimeUser
    }
    
    func goToChat() {
        state = .goToChatRoom
    }
    
    func signIn() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let configuration = GIDConfiguration(clientID: clientID)
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
    }
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
            if let error = error {
                print(error.localizedDescription)
            } else  {
                checkUserName()
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        SocketHandler.shared.closeConnection()
        do {
            try Auth.auth().signOut()
            state = .signedOut
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func checkUserName() {
        let user = Auth.auth().currentUser
        let mSock = connectToServer()
        mSock.on("connected") { data, ack in
            if let username = user?.displayName {
                if !username.isEmpty {
                    print("USER: " + username)
                    if let userID = user?.uid {
                        let initData = InitData(uName: username, uid: userID)
                        do {
                            let jData = try JSONEncoder().encode(initData)
                            mSock.emit("checkUsername", jData)
                            mSock.on("NEW_USER") {[weak self] data, ack in
                                print("NEW_USER TRIGGERED")
                                self?.state = .firstTimeUser
                            }
                            mSock.on("USER_EXISTS") {[weak self] data, ack in
                                print("USER_EXISTS TRIGGERED")
                                self?.state = .signedIn
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    private func connectToServer() -> SocketIOClient {
        SocketHandler.shared.establishConnection()
        let mSock = SocketHandler.shared.getSocket()
        return mSock
    }
}
