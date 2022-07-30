//
//  CreateUserNameView.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/24/22.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct CreateUserNameView: View {
    @State var username = ""
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            HStack{
                Image("froglogo")
                    .resizable()
                    .aspectRatio(contentMode:.fit)
                    .frame(width: 250, height:250)
                    .background(
                        Circle()
                            .fill(.red)
                    )
            }
            Spacer()
                .frame(height:50)
            Text("Hey Stranger")
                .font(Font.custom("modeseven", size:32))
                .foregroundColor(.red)
            Spacer()
                .frame(height:50)
            
            HStack{
                Text("Username:")
                    .font(Font.custom("modeseven",size:28))
                    .foregroundColor(.cyan)
                    .padding([.leading], 20)
                VStack {
                    TextField("Enter name", text: $username)
                        .textFieldStyle(.automatic)
                        .font(Font.custom("modeseven",size:16))
                        .foregroundColor(.cyan)
                        .padding(.trailing, 20)
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 30)
                        .background(Color.cyan)
                }
                .padding()
            }
            
            Spacer()
                .frame(height:50)
            
            Button {
                print("loggin in")
                sendUsername()
            } label: {
                Text("Submit")
                    .font(Font.custom("modeseven", size:32))
                    .foregroundColor(.red)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.bgColor)
    }
    
    private func sendUsername() {
        let mSock = SocketHandler.shared.getSocket()
        let user = Auth.auth().currentUser
		
		// Request to update username here
		let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
		changeRequest?.displayName = username
		changeRequest?.commitChanges() {error in
			print(error?.localizedDescription ?? "Change successful")
		}
        if let userID = user?.uid {
            let initData = InitData(uName: username, userID: userID)
            do {
                let jData = try JSONEncoder().encode(initData)
                mSock.emit("checkUsername", jData)
                mSock.on("NEW_USER") {data, ack in
                    print("New user")
                    mSock.emit("signUp", jData)
                    viewModel.goToRooms()
                }
                mSock.on("USER_EXISTS") {data, ack in
                    print("User already exists")
                    username = ""
                }
            } catch {
                print(error)
            }
        }
    }
}

struct CreateUserNamePreview: PreviewProvider {
    static var previews: some View {
        CreateUserNameView()
    }
}
