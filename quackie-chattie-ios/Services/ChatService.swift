//
//  ChatService.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/27/22.
//

import Foundation
import Combine
import FirebaseAuth
import SocketIO

extension String: Error {}

final class ChatService: ObservableObject {
    static let mSock = SocketHandler.shared.getSocket()
    
    private let messageSubject = PassthroughSubject<Message, Never>()
    private let mSock = SocketHandler.shared.getSocket()

    let receivedMessage: AnyPublisher<Message, Never>
    
    init() {
        receivedMessage = messageSubject.eraseToAnyPublisher()
        self.getUpdates()
    }
    
    func send(rName: String, text: String, user: String) {
        print("SENDING STUFF")
        let mSock = SocketHandler.shared.getSocket()
                let initData = Send(uName: user, content: text, rName: rName)
                do {
                    let jData = try JSONEncoder().encode(initData)
                    mSock.emit("newMessage", jData)
                    DispatchQueue.global().async(
                    execute: {
                        DispatchQueue.main.sync {
                            self.messageSubject.send(Message(sender: user, message_text: text, room_name: rName))
                        }
                    })
                } catch {
                    print(error)
                }
    }
    
    func getUpdates() {
        print("Listening for new messages")
        do {
            mSock.on("update") { data, ack in
                print("GETTING NEW MESSAGES")
                SoundModel.instance.play()
                let stuff = data[0] as! String
                guard let json = try? JSONSerialization.jsonObject(with: stuff.data(using: .utf8)!, options: []) as? [String: Any] else {return}
                let temp = Message(sender: json["uName"] as! String, message_text: json["content"] as! String, room_name: json["rName"] as! String)
                DispatchQueue.global().async(
                execute: {
                    DispatchQueue.main.sync {
                        self.messageSubject.send(temp)
                    }
                })
            }
        }
    }
}
