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
    
    let receivedMessage: AnyPublisher<Message, Never>
    
    init() {
        receivedMessage = messageSubject.eraseToAnyPublisher()
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
    
    func getUpdates(temp: Message) {
        let message = temp
        DispatchQueue.global().async(
        execute: {
            DispatchQueue.main.sync {
                self.messageSubject.send(message)
            }
        })

    }
}
