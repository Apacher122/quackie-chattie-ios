//
//  ChatRoomView.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/24/22.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Combine

struct ChatRoomView: View {
    @ObservedObject private var keyboardObserer = KeyboardObserver()
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @EnvironmentObject private var store: AppStore
    @State private var messages: [Message] = []
    @State private var subscriptions: Set<AnyCancellable> = []
    @State private var msg = Message(sender: "", message_text: "", room_name: "")
    
    let username = Auth.auth().currentUser?.displayName
    let mSock = SocketHandler.shared.getSocket()
    let user = Auth.auth().currentUser
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        print("Going back")
                        leaveRoom()
                    } label : {
                        Text("Back")
                            .font(Font.custom("modeseven", size: 20))
                            .foregroundColor(.red)
                            .padding(.leading)
                    }
                    Spacer()
                        .frame(width:20)
                    Image("wydia")
                        .resizable()
                        .aspectRatio(contentMode:.fit)
                        .frame(width: 50, height:50)
                    Spacer()
                        .frame(width:20)
                    Text("Start Quackin")
                        .font(Font.custom("modeseven", size:29))
                        .foregroundColor(.cyan)
                        .padding(.trailing)
                    Spacer()
                    Spacer()
                }
                Divider()
                    .frame(height:1)
                    .background(Color.cyan)
                NavigationView {
                    ZStack {
                        Color.bgColor.edgesIgnoringSafeArea(.all)
                        ScrollViewReader { scrollView in
                            ScrollView(.vertical) {
                                LazyVStack {
                                    ForEach(0..<messages.count, id: \.self){ i in
                                        ChatMessageRow(message: self.messages[i],
                                                       isIncoming: self.messages[i].sender != username,
                                                       isLasFromContact: false)
                                        .listRowInsets(EdgeInsets(
                                            top: i == 0 ? 16 : 0,
                                            leading: 12,
                                            bottom: 6,
                                            trailing: 12))

                                    }
                                    .onChange(of: messages.count) { _ in
                                        scrollView.scrollTo(messages.count - 1)
                                    }
                                    .listRowBackground(Color.bgColor)
                                }
                            }
                            .listStyle(.plain)
                        }
                    }
                    .navigationTitle("")
                    .navigationBarHidden(true)
                }
                ChatTextField(sendAction: sendMessage)
                    .padding(.bottom, keyboardObserer.keyboardHeight)
                    .animation(.easeInOut(duration: 0.3), value: false)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.bgColor)
        }
        .onAppear(perform: updateMessages)
        .onAppear(perform: fetchPastMessages)
    }
    
    
    private func leaveRoom() {
        if let username = user?.displayName {
            let roomName = viewModel.room_name
            if !username.isEmpty {
                let initData = Rooms(room_id: "", room_name: roomName, user_name: username)
                do {
                    let jData = try JSONEncoder().encode(initData)
                    mSock.emit("leave_room", jData)
                    closeSocketListeners()
                    viewModel.goToRooms()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func sendMessage(message: String) {
        // hide keyboard upon sending message
        hideKeyboard()
        SoundModel.instance.play()
        let user = Auth.auth().currentUser
        if let username = user?.displayName {
            if !username.isEmpty {
                let roomName = viewModel.room_name
                store.state.chatService.send(rName: roomName, text: message, user: username)
            }
        }
    }
    
    private func updateMessages() {
        store.state.chatService.receivedMessage.sink { message in
            self.messages.append(message)
        }.store(in: &subscriptions)
    }
    
    private func fetchPastMessages() {
        if let username = user?.displayName {
            if !username.isEmpty {
                let roomName = viewModel.room_name
                let initData = Rooms(room_id: "", room_name: roomName, user_name: "")
                do {
                    let jData = try JSONEncoder().encode(initData)
                    mSock.emit("getMessages", jData)
                    mSock.on("populateMessages") { data, ack in
                        print(type(of: data[0]))
                        let stuff = data[0] as! String
                        guard let json = try? JSONSerialization.jsonObject(with: stuff.data(using: .utf8)!, options: []) as? [String: Any] else { return }
                        let temp = Message(sender: json["sender"] as! String, message_text: json["message_text"] as! String, room_name: json["room_name"] as! String)
                        self.messages.append(temp)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func closeSocketListeners() {
        mSock.off("populateMessages")
    }
}

struct ChatRoomPreview: PreviewProvider {
    static var previews: some View {
        ChatRoomView()
    }
}

// This should close the keyboard
#if canImport(UIKit)
extension View {
    func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
