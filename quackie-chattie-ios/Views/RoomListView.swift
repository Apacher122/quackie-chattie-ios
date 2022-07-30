//
//  RoomListView.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/24/22.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct RoomsListView: View {
    @State var roomName = ""
    @State private var rooms = [String]()
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    let mSock = SocketHandler.shared.getSocket()
    let user = Auth.auth().currentUser

    var body: some View {
        VStack {
            HStack {
                Button {
                    print("logging out")
                    logOut()
                } label : {
                    Text("Logout")
                        .font(Font.custom("modeseven", size: 20))
                        .foregroundColor(.red)
                        .padding(.leading)
                }
                Spacer()
                Text("Rooms")
                    .font(Font.custom("modeseven", size:32))
                    .foregroundColor(.cyan)
                    .padding(.trailing)
                Spacer()
                Spacer()
            }
            Spacer()
                .frame(height:1)
                .background(.cyan)
            Spacer()
                .frame(height:50)
            NavigationView {
                ZStack {
                    Color.bgColor.edgesIgnoringSafeArea(.all)
                    List {
                        ForEach(self.rooms, id: \.self) { room in
                            Button {
                                print("loggin in")
                                roomName = room
                                joinRoom()
                            } label: {
                                Text(room)
                                    .font(Font.custom("modeseven", size:28))
                                    .foregroundColor(.red)
                            }
                            .background(Color("bg_color"))
                        }
                        .listRowBackground(Color.bgColor)
                    }
                    .listStyle(.plain)
                    .listRowBackground(Color("bg_color"))
                }
                .navigationTitle("")
                .navigationBarHidden(true)
                .onAppear {
                    self.populateRooms()
                }
            }
            
            HStack{
                VStack {
                    TextField("Create or join room", text: $roomName)
                        .textFieldStyle(.automatic)
                        .font(Font.custom("modeseven",size:16))
                        .foregroundColor(.cyan)
                        .padding(.trailing, 20)
                        .onSubmit{
                            joinRoom()
                        }
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 30)
                        .background(Color.cyan)
                }.padding()
                Button {
                    print("joining room")
                    joinRoom()
                } label: {
                    Image("joinButton")
                        .resizable()
                        .aspectRatio(contentMode:.fit)
                        .frame(width: 36, height:36)
                }.padding(.trailing)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.bgColor)
    }
    
    private func populateRooms() {
        if let username = user?.displayName {
            if !username.isEmpty {
                if let userID = user?.uid {
                    let initData = InitData(uName: username, uid: userID)
                    do {
                        let jData = try JSONEncoder().encode(initData)
                        mSock.emit("getRooms", jData)
                        mSock.on("populate_chat_list") { data, ack in
                            print(type(of: data[0]))
                            print("DECODING")
                            let stuff = data[0] as! String
                            guard let json = try? JSONSerialization.jsonObject(with: stuff.data(using: .utf8)!, options: []) as? [String: Any] else { return }
                            print(json["room_name"]!)
                            rooms.append(json["room_name"] as! String)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }

    
    private func joinRoom() {
        if let username = user?.displayName {
            if !username.isEmpty {
                let initData = Rooms(room_id: "", room_name: roomName, user_name: username)
                viewModel.room_name = roomName
                roomName = ""
                do {
                    let jData = try JSONEncoder().encode(initData)
                    mSock.emit("joinRoom", jData)
                    viewModel.goToChat()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func logOut() {
        viewModel.signOut()
        closeSockets()
    }
    
    private func closeSockets() {
        mSock.off("populate_chat_list")
    }
}

struct RoomsListPreview: PreviewProvider {
    static var previews: some View {
        RoomsListView()
    }
}
